class DailyKanbanMetric < ApplicationRecord
  belongs_to :user
  enum metric_type: [:sprint, :client_kanban, :bug_kanban ]
end
