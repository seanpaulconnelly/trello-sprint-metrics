namespace :sprint do
  
  # FOR EACH USER WITH A TRELLO ID, GET ALL OF THEIR CARDS ON THE IN PROGRESS BOARD (INCLUDE NAME, LIST)
  # LOOP THROUGH EACH CARD IN RESPONSE...
  #   IF CARD EXISTS WITH MATCHING TRELLO ID
  #     MAKE SURE IT'S ASSIGNED TO THE USER
  #     AND IF IT IS MARKED AS COMPLETED YET
  #       UPDATE NAME, LIST, ESTIMATE, STARTED_AT, COMPLETED_AT
  #   ELSE 
  #     CREATE ONE, SETTING TRELLO_ID, TRELLO_CARD_NAME, LIST, ESTIMATE, STARTED_AT, COMPLETED_AT
  #      AND PUSH IT ONTO THE USERS LIST OF CARDS

  # rake sprint:calculate_daily_stats
  desc "loop through everyone's cards on the sprint board and create/update them"
  task calculate_daily_stats: :environment do
    User.where("trello_id IS NOT NULL").each do |user|
      path = "boards/#{TrelloHelper.trello_board}/members/#{user.trello_id}/cards"
      params = "&cards=open&card_fields=name&fields=name,idList"
      trello_cards = TrelloHelper.call_trello(path, params)
      trello_cards.each do |trello_card|
        db_card = Card.where(metric_type: 0).find_by(trello_id: trello_card["id"])
        if db_card
          unless db_card.users.exists?(trello_id: user.trello_id)
            user.cards << db_card
          end
          if !db_card.completed_at?
            db_card.update!(
              trello_card_name: trello_card["name"],
              list: List.find_by(trello_id: trello_card["idList"]),
              estimate: trello_card["name"].scan((/\(.*?\)/)).first.to_s.delete('()').to_i,
              started_at: db_card.started_today? ? Time.now : nil,
              completed_at: db_card.completed_today? ? Time.now : nil
              )
          end
        else
          db_card = Card.new(
            trello_id: trello_card["id"],
            trello_card_name: trello_card["name"],
            list: List.find_by(trello_id: trello_card["idList"]),
            estimate: trello_card["name"].scan((/\(.*?\)/)).first.to_s.delete('()').to_i,
            metric_type: 0
            )
          if db_card.save
            db_card.update(
              started_at: db_card.started_today? ? Time.now : nil,
              completed_at: db_card.completed_today? ? Time.now : nil
              )
          else
            Rails.logger.error "!!!!!!!! ERROR SAVING DB_CARD: #{db_card}"
          end
          user.cards << db_card
        end
      end
    end
  end


  # rake sprint:cleanup
  desc "destroy our instance of sprint board cards if they become archived"
  task cleanup: :environment do
    User.where("trello_id IS NOT NULL").each do |user|
      path = "boards/#{TrelloHelper.trello_board}/members/#{user.trello_id}/cards"
      params = "&filter=closed&card_fields=name&fields=name"
      trello_cards = TrelloHelper.call_trello(path, params)
      trello_cards.each do |trello_card|
        db_card = Card.find_by(trello_id: trello_card["id"])
        if db_card
          db_card.destroy
        end
      end
    end
  end


  # rake sprint:start_for_date start_date='2017-05-08'
  desc "check for a sprint scheduled on a date (or today if you don't pass one) and start it"
  task start_for_date: :environment do
    start_date = ENV['start_date'] || Time.now
    sprint = Sprint.where(scheduled_starts_at: start_date).first
    if sprint
      sprint.update!(actual_started_at: Time.now)
    else
      Rails.logger.error "!!!!!!!! NO SPRINT STARTING ON #{start_date}"
    end
  end


  # rake sprint:end_for_date end_date='2017-05-22'
  desc "check for a sprint ending on a date (or today if you don't pass one), end it, calculate archived metrics, and remove completed user sprint cards"
  task end_for_date: :environment do
    end_date = ENV['end_date'] || Time.now
    sprint = Sprint.where(scheduled_ends_at: end_date).where("actual_ended_at IS NULL").first
    if sprint
      # loop through user and create an archived metric for the sprint
      User.where("trello_id IS NOT NULL").each do |user|
        ArchivedMetric.create!(
          sprint: sprint,
          user: user,
          points_velocity: user.cards.where(metric_type: 0).where("completed_at <= ?", end_date).sum(:estimate),
          cards_velocity: user.cards.where(metric_type: 0).where("completed_at <= ?", end_date).count,
          unfinished_points: user.cards.where(metric_type: 0).where("completed_at IS NULL").sum(:estimate),
          unfinished_cards: user.cards.where(metric_type: 0).where("completed_at IS NULL").count
        )
      end

      # soft delete completed sprint cards
      Card.all.where(metric_type: 0).where("completed_at <= ?", end_date).destroy_all

      # end the sprint
      sprint.update(actual_ended_at: Time.now)
    else
      Rails.logger.error "!!!!!!!! NO SPRINT ENDING ON #{end_date}"
    end
  end

end
