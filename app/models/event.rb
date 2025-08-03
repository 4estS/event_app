class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :event_tags, dependent: :destroy
  has_many :tags, through: :event_tags

  has_one_attached :image

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

  broadcasts_to ->(event) { [ event.user, :events ] }, inserts_by: :prepend, target: :events

  validates :title, :description, :starts_at, :ends_at, presence: true
  validates :event_type, presence: true
  validates :status, presence: true
  validates :slug, presence: true, uniqueness: true, length: { maximum: 63 }
  validate :maximum_five_tags
  validate :image_size_within_limit

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

  def maximum_five_tags
    errors.add(:tags, "can't have more than 5") if tags.size > 5
  end

  def generate_slug
    return if slug.present? # Prevent overwriting an existing slug

    base_slug = title.to_s.parameterize[0...63]
    self.slug = unique_slug(base_slug)
  end

  def unique_slug(base_slug)
    slug_candidate = base_slug
    count = 2

    while Event.where.not(id: id).exists?(slug: slug_candidate)
      suffix = "-#{count}"
      slug_candidate = "#{base_slug[0...(63 - suffix.length)]}#{suffix}"
      count += 1
    end

    slug_candidate
  end

  def image_size_within_limit
    return unless image.attached?

    if image.blob.byte_size > 2.megabytes
      errors.add(:image, "is too large. Maximum size is 2MB.")
    end
  end
end
