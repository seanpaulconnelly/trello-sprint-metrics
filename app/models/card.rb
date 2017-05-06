class Card < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :list

  def completed_today?
    !self.completed_at? && self.in_completed_list?
  end

  def in_completed_list?
    self.list.status == :done
  end

  def in_working_list?
    self.list.status == :working
  end

  def started_today?
    !self.started_at? && self.in_working_list?
  end

  def started_and_completed_in_same_day?
    !self.started_at? && self.completed_at?
  end

  def status
    self.list.status
  end
end
