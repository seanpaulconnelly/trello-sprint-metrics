class List < ApplicationRecord
  has_many :cards, dependent: :destroy
  enum status: [ :backlog, :sprint_backlog, :working, :done ]
end
