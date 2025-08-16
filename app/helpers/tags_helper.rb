module TagsHelper
  def tag_badge(tag)
    link_to tag.name,
            events_path(tag_id: tag.id), # ← was tag_path(tag)
            class: "card-event__tag"
  end
end
