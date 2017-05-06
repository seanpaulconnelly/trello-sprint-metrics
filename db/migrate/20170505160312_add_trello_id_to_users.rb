class AddTrelloIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :trello_id, :string
  end
end
