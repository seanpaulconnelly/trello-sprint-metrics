class RenameUsersCards < ActiveRecord::Migration[5.1]
  def change
    rename_table :users_cards, :cards_users
  end
end
