namespace :sprint do
  task calculate_daily_stats: :environment do
    User.where("trello_id IS NOT NULL").each do |user|
      path = "boards/#{TrelloHelper.trello_board}/members/#{user.trello_id}/cards"
      params = "&cards=open&card_fields=name&fields=name,idList"
      cards = TrelloHelper.call_trello(path, params)
      cards.each do |card|
        puts card["id"]
        puts trello_name = card["name"]
        puts estimate = card["name"][(/\(.*?\)/)].to_s.delete('()').to_i
        puts card["idList"]
      end
    end

    
    # GET ALL CARDS FOR EACH MEMBER, (INCLUDE NAME, LIST)
    # LOOP THROUGH EACH CARD IN RESPONSE...
    #   IF MEMBER.CARD EXISTS WITH MATCHING TRELLO ID
    #     IF IT IS NOT COMPLETED YET
    #       UPDATE LIST, ESTIMATE, ADDED_TO_CURRENT_LIST_AT, STARTED_AT, COMPLETED_AT
    #   ELSE 
    #     CREATE ONE, SET TRELLO_ID, LIST, ESTIMATE, ADDED_TO_CURRENT_LIST_AT, STARTED_AT, COMPLETED_AT
    #       IF CARD IS IN COMPLETED LIST AND STARTED_AT IS NULL
    #           STARTED_AT SHOULD EQL COMPLETED_AT
    

  end

  
  # task end: :environment do |task, args|
  #   DEFAULT TO CURRENT SPRINT UNLESS START_DATE / END_DATE ARE PASSED IN ARGS
  # end

end
