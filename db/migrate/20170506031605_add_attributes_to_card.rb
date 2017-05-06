class AddAttributesToCard < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :trello_card_name, :string
    add_reference :cards, :list, foreign_key: true
  end
end
