class Sprint < ApplicationRecord
  acts_as_paranoid
  has_many :archived_metrics, dependent: :destroy

  validates :scheduled_starts_at, :scheduled_ends_at, presence: true
end
