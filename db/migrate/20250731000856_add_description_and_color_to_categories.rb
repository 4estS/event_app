class AddDescriptionAndColorToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :description, :text
    add_column :categories, :color, :string
  end
end
