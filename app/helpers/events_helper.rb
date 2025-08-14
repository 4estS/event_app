module EventsHelper
  def event_image(event)
    alt_text = event.title.presence || event.slug.presence || "Event image"

    if event.image.attached?
      image_tag url_for(event.image), class: "cart-event_image max-w-full h-auto", alt: alt_text
    else
      image_tag "default-event.jpg", class: "card-event__image max-w-full h-auto", alt: alt_text
    end
  end
end
