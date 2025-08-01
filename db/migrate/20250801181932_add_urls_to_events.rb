class AddUrlsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :website_url, :string
    add_column :events, :ticket_url, :string
  end
end
