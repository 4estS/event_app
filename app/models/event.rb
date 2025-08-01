class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :description, :starts_at, :ends_at, presence: true
  validates :event_type, presence: true
  validates :status, presence: true
  validate :maximum_five_tags

  broadcasts_to ->(event) { [ event.user, :events ] }, inserts_by: :prepend, target: :events

  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags

  enum :event_type, {
    free: 0,
    paid: 1,
    ticket_required: 2,
    donation_based: 3
  }
  enum :status, {
    draft: 0,
    pending: 1,
    published: 2,
    cancelled: 3,
    archived: 4
  }, default: :draft

  private

  def maximum_five_tags
   errors.add(:tags, "can't have more than 5") if tags.size > 5
  end
end
