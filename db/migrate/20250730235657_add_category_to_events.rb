class AddCategoryToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :event_posts, :category, null: true, foreign_key: true
  end
end
