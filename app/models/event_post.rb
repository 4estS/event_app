class EventPost < ApplicationRecord
  belongs_to :user

  belongs_to :category

  validates :title, :description, :starts_at, :ends_at, presence: true
end
