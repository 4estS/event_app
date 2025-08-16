class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :event_tags, dependent: :destroy
  has_many :tags, -> { order(:name) }, through: :event_tags

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
  # Process the image only after the blob is fully persisted and available
  after_commit :normalize_image_to_1920x1080, on: [ :create, :update ]

  def to_param
    slug
  end

  def display_image(size: :large)
    return unless image.attached?

    case size
    when :large
      image.variant(resize_to_fill: [ 1920, 1080 ]).processed
    when :medium
      image.variant(resize_to_fill: [ 960, 540 ]).processed
    when :thumb
      image.variant(resize_to_fill: [ 480, 270 ]).processed
    when :dashboard
      image.variant(resize_to_fill: [ 170, 96 ]).processed
    end
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

  def normalize_image_to_1920x1080
    return unless image.attached?

    # Only process when the image was just (re)attached
    unless previous_changes.key?("image_attachment")
      return
    end

    # Skip if already normalized (avoid reprocessing loop)
    return if image.blob.metadata[:normalized] == true

    require "image_processing/mini_magick"
    require "mini_magick"

    image.blob.open do |file|
      mm = MiniMagick::Image.new(file.path)

      # Don’t upscale small images; only crop/resize when larger than target
      if mm.width >= 1920 && mm.height >= 1080
        processed = ImageProcessing::MiniMagick
                      .source(file)
                      .resize_to_fill(1920, 1080, gravity: "Center")
                      .call

        # Attach the processed blob and mark it as normalized
        image.attach(
          io: File.open(processed.path),
          filename: image.filename,
          content_type: image.content_type,
          metadata: image.blob.metadata.merge(normalized: true)
        )
      end
    end
  end
end
