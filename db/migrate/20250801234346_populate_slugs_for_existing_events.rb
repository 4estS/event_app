class PopulateSlugsForExistingEvents < ActiveRecord::Migration[8.0]
  def up
    Event.reset_column_information

    Event.find_each do |event|
      next if event.slug.present?

      base_slug = event.title.to_s.parameterize[0...63]
      slug = base_slug
      count = 2

      while Event.where.not(id: event.id).exists?(slug: slug)
        suffix = "-#{count}"
        slug = "#{base_slug[0...(63 - suffix.length)]}#{suffix}"
        count += 1
      end

      event.update_column(:slug, slug)
    end
  end

  def down
    # You probably don't want to delete slugs, so this is a no-op
  end
end
