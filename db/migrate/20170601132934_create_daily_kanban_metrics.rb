class CreateDailyKanbanMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_kanban_metrics do |t|
      t.references :user, foreign_key: true
      t.integer :cards_in_progress
      t.integer :cards_completed
      t.integer :points_in_progress
      t.integer :points_completed

      t.timestamps
    end
  end
end
