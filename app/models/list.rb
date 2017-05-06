class List < ApplicationRecord
  has_many :cards
  enum status: [ :backlog, :sprint_backlog, :working, :done ]
end
