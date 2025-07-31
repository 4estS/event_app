class BackfillCategoryIdOnEventPosts < ActiveRecord::Migration[8.0]
  def up
    default_category = Category.first || Category.create!(name: "Default")

    EventPost.where(category_id: nil).update_all(category_id: default_category.id)

    change_column_null :event_posts, :category_id, false
  end

  def down
    change_column_null :event_posts, :category_id, true
  end
end
