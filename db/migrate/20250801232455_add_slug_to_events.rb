
class AddSlugToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :slug, :string, limit: 63
    add_index :events, :slug, unique: true
  end
end
