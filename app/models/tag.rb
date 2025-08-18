class Tag < ApplicationRecord
  has_many :event_tags, dependent: :destroy
  has_many :events, through: :event_tags

  validates :name, presence: true, uniqueness: true

  def to_param
    name.parameterize
  end
end
