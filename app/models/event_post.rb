class EventPost < ApplicationRecord
  belongs_to :user

  validates :title, :description, :starts_at, :ends_at, presence: true
end
