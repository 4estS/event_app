class EventTag < ApplicationRecord
  belongs_to :event
  belongs_to :tag

  validates :event_id, uniqueness: { scope: :tag_id } # avoid duplicates
end
