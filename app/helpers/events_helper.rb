module EventsHelper
  def event_image(event)
    alt_text = event.title.presence || event.slug.presence || "Event image"
    image_classes = "card-event__image max-w-full h-auto"
    src = event.image.attached? ? url_for(event.image) : "default-event.jpg"

    image_tag src, class: image_classes, alt: alt_text
  end
end
