class SetDefaultStatusOnExistingEvents < ActiveRecord::Migration[7.1]
  def up
    Event.where(status: nil).update_all(status: Event.statuses[:draft])
  end

  def down
    # optional: no-op or reset to nil
  end
end
