class AddGroupRefToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :group, null: true, foreign_key: { to_table: :notifications }
  end
end
