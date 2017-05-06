class CreateCardsAndUserLinkage < ActiveRecord::Migration[5.1]
  def change
    
    create_table :cards do |t|
      t.string :trello_id
      t.string :trello_card_name
      t.integer :estimate
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    create_table :users_cards do |t|
      t.belongs_to :user, index: true
      t.belongs_to :card, index: true

      t.timestamps
    end

  end
end
