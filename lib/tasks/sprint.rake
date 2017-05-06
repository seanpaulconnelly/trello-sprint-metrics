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

  task calculate_daily_stats: :environment do
    User.where("trello_id IS NOT NULL").each do |user|
      path = "boards/#{TrelloHelper.trello_board}/members/#{user.trello_id}/cards"
      params = "&cards=open&card_fields=name&fields=name,idList"
      trello_cards = TrelloHelper.call_trello(path, params)
      trello_cards.each do |trello_card|
        db_card = Card.find_by(trello_id: trello_card["id"])
        if db_card
          unless db_card.users.exists?(trello_id: user.trello_id)
            user.cards << db_card
          end
          if !db_card.completed_at?
            db_card.update(
              trello_card_name: trello_card["name"],
              list: List.find_by(trello_id: trello_card["idList"]),
              estimate: trello_card["name"].scan((/\(.*?\)/)).first.to_s.delete('()').to_i,
              started_at: Time.now ? db_card.started_today? || db_card.started_and_completed_in_same_day? : nil,
              completed_at: Time.now ? db_card.completed_today? : nil
              )
          end
        else
          db_card = Card.new(
            trello_id: trello_card["id"],
            trello_card_name: trello_card["name"],
            list: List.find_by(trello_id: trello_card["idList"]),
            estimate: trello_card["name"].scan((/\(.*?\)/)).first.to_s.delete('()').to_i
            )
          if db_card.save
            db_card.update(
              started_at: Time.now ? db_card.in_working_list? || db_card.in_completed_list? : nil,
              completed_at: Time.now ? db_card.in_completed_list?: nil
              )
          else
            Rails.logger.error "!!!!!!!! ERROR SAVING DB_CARD: #{db_card}"
          end
          user.cards << db_card
        end
      end
    end
  end

  
  # task end: :environment do |task, args|
  #   DEFAULT TO CURRENT SPRINT UNLESS START_DATE / END_DATE ARE PASSED IN ARGS
  # end

end
