class ChangeEventTypeDefaultInEvents < ActiveRecord::Migration[7.1]
  def change
    change_column_default :events, :event_type, from: nil, to: 0

    # Define anonymous model to avoid loading the main Event model
    events = Class.new(ActiveRecord::Base) do
      self.table_name = 'events'
    end

    events.where(event_type: nil).update_all(event_type: 0)

    change_column_null :events, :event_type, false
  end
end
