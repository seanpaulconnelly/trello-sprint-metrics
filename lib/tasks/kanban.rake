namespace :kanban do

  # rake kanban:sync_cards
  desc "loop through everyone's cards on the kanban board and create/update them"
  task sync_cards: :environment do
    User.where("trello_id IS NOT NULL").each do |user|
      path = "boards/#{TrelloHelper.kanban_board}/members/#{user.trello_id}/cards"
      params = "&cards=open&card_fields=name&fields=name,idList"
      trello_cards = TrelloHelper.call_trello(path, params)
      trello_cards.each do |trello_card|
        db_card = Card.where(metric_type: 1).find_by(trello_id: trello_card["id"])
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
            metric_type: 1
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


  # rake kanban:cleanup
  desc "destroy our instance of kanban board cards if they become archived on Trello"
  task cleanup: :environment do
    User.where("trello_id IS NOT NULL").each do |user|
      path = "boards/#{TrelloHelper.kanban_board}/members/#{user.trello_id}/cards"
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


  # rake kanban:calculate_daily_metrics
  desc "go through our kanban cards, calculate and store daily WIP metrics, and then destroy our instance of each card"
  task calculate_daily_metrics: :environment do
    # loop through user and create an archived metric for the sprint
    User.where("trello_id IS NOT NULL").each do |user|
      DailyKanbanMetric.create!(
        user: user,
        points_completed: user.cards.where(metric_type: 1).where("completed_at IS NOT NULL").sum(:estimate),
        cards_completed: user.cards.where(metric_type: 1).where("completed_at IS NOT NULL").count,
        points_in_progress: user.cards.where(metric_type: 1).where("completed_at IS NULL").sum(:estimate),
        cards_in_progress: user.cards.where(metric_type: 1).where("completed_at IS NULL").count
      )
    end

    # soft delete all kanban cards
    Card.all.where(metric_type: 1).destroy_all
  end
end
