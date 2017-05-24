class CreateSprints < ActiveRecord::Migration[5.1]
  def change
    create_table :sprints do |t|
      t.datetime :scheduled_starts_at
      t.datetime :scheduled_ends_at
      t.datetime :actual_started_at
      t.datetime :actual_ended_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :sprints, :deleted_at
  end
end
