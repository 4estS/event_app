class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :description, :starts_at, :ends_at, presence: true
  validates :event_type, presence: true
  validate :maximum_five_tags

  broadcasts_to ->(event) { [ event.user, :events ] }, inserts_by: :prepend, target: :events

  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags

  enum :event_type, {
    free: 0,
    paid: 1,
    ticket_required: 2,
    donation_based: 3 }

  private

  def maximum_five_tags
   errors.add(:tags, "can't have more than 5") if tags.size > 5
  end
end
