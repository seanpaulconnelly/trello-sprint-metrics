class Card < ApplicationRecord
  acts_as_paranoid
  has_and_belongs_to_many :users
  belongs_to :list
  before_destroy { users.clear }
  enum metric_type: [ :sprint, :kanban ]

  def completed_today?
    !self.completed_at? && self.in_completed_list?
  end

  def in_completed_list?
    self.list.status == 'done'
  end

  def in_working_list?
    self.list.status == 'working'
  end

  def started_today?
    !self.started_at? && self.in_working_list?
  end

end
