class Event < ApplicationRecord
  belongs_to :user

  belongs_to :category

  validates :title, :description, :starts_at, :ends_at, presence: true

  broadcasts_to ->(event) { [ event.user, :events ] }, inserts_by: :prepend

  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags

  validate :maximum_five_tags

  private

  def maximum_five_tags
    errors.add(:tags, "can't have more than 5") if tags.size > 5
  end
end
