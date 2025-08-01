# db/migrate/20250801121000_update_slug_for_events.rb
class UpdateSlugForEvents < ActiveRecord::Migration[8.0]
  def up
    Event.reset_column_information

    Event.find_each do |event|
      next if event.slug.present?

      base_slug = event.title.to_s.parameterize[0...100]
      slug = base_slug
      count = 2

      while Event.where.not(id: event.id).exists?(slug: slug)
        suffix = "-#{count}"
        slug = "#{base_slug[0...(100 - suffix.length)]}#{suffix}"
        count += 1
      end

      event.update_column(:slug, slug)
    end
  end

  def down
    # You probably don't want to remove the column if it's already there
    # But if you're okay with it, uncomment below:
    # remove_index :events, :slug
    # remove_column :events, :slug
  end
end
