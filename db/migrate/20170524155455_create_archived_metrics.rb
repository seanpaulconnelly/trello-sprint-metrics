class CreateArchivedMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :archived_metrics do |t|
      t.references :sprint, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :points_velocity
      t.integer :cards_velocity
      t.integer :unfinished_points
      t.integer :unfinished_cards
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :archived_metrics, :deleted_at
  end
end
