class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string :trello_id
      t.string :trello_list_name
      t.integer :status

      t.timestamps
    end
  end
end
