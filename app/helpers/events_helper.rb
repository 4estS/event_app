module EventsHelper
  EVENT_IMAGE_SIZES = {
    large:  [ 1920, 1080 ],
    medium: [ 960, 540 ],
    thumb:  [ 480, 270 ]
  }.freeze

  DEFAULT_IMAGES = {
    large:  "default-event-1920x1080.jpg",
    medium: "default-event-960x540.jpg",
    thumb:  "default-event-480x270.jpg"
  }.freeze

  def event_image(event, size: :large, classes: "card-event__image max-w-full h-auto")
    width, height = EVENT_IMAGE_SIZES.fetch(size, EVENT_IMAGE_SIZES[:medium])
    alt_text = event.title.presence || event.slug.presence || "Event image"

    if event.image.attached?
      image_tag event.display_image(size: size),
                alt: alt_text,
                class: classes,
                width: width,
                height: height,
                loading: "lazy",
                decoding: "async"
    else
      image_tag DEFAULT_IMAGES.fetch(size, DEFAULT_IMAGES[:medium]),
                alt: alt_text,
                class: classes,
                width: width,
                height: height,
                loading: "lazy",
                decoding: "async"
    end
  end
end
