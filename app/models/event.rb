class Event < ApplicationRecord
  belongs_to :user

  belongs_to :category

  validates :title, :description, :starts_at, :ends_at, presence: true

  broadcasts_to ->(event) { [ event.user, :events ] }, inserts_by: :prepend
end
