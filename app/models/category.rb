class Category < ApplicationRecord
  has_many :event_posts, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end
