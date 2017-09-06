namespace :lists do
  
  # RUN THIS INITIALLY TO SET UP LISTS
  # fetches all lists for the trello board and stores them in our DB
  # if a list with the trello_id already exists, the name is updated
  # ** will not clean up lists that have been archived or moved to another Trello board

  task :update_from_trello, [:board_id] => :environment do |task, args|
    path = "boards/#{args.board_id}/lists"
    params = "&fields=name"
    trello_lists = TrelloHelper.call_trello(path, params)
    trello_lists.each do |trello_list|
      db_list = List.find_by(trello_id: trello_list["id"])
      if db_list
        db_list.update(trello_list_name: trello_list["name"])
      else
        List.create(trello_list_name: trello_list["name"], trello_id: trello_list["id"], status:0)
      end
    end
  end
end
