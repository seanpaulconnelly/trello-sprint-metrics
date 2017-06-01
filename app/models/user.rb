class User < ApplicationRecord
  authenticates_with_sorcery!
  has_and_belongs_to_many :cards
  has_many :archived_metrics, dependent: :destroy
  has_many :daily_kanban_metrics, dependent: :destroy

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
end
