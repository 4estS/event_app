class UpdateEventTimeColumns < ActiveRecord::Migration[7.1]
  def change
    change_column :events, :starts_at, :time
    change_column :events, :ends_at, :time

    add_column :events, :starts_on, :date
  end
end
