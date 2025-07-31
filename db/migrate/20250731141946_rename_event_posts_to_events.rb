class RenameEventPostsToEvents < ActiveRecord::Migration[7.1]
  def change
    rename_table :event_posts, :events
  end
end
