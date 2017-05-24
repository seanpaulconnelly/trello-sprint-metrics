class ArchivedMetric < ApplicationRecord
  acts_as_paranoid
  belongs_to :sprint
  belongs_to :user
end
