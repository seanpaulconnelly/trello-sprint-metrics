namespace :lists do
  task update_from_trello: :environment do
    # fetch all lists for in progress board and store them in the DB
    # if a list with the trello_id already exists, update the name
  end
end
