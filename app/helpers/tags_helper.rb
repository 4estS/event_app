module TagsHelper
  def tag_badge(tag)
    link_to tag.name,
            tag_path(tag),
            class: "card-event__tag"
  end
end
