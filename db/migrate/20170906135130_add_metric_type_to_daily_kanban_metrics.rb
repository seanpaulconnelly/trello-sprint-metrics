class AddMetricTypeToDailyKanbanMetrics < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_kanban_metrics, :metric_type, :integer
  end
end
