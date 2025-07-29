class CreateEventPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :event_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
