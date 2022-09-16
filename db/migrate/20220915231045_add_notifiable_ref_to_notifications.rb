class AddNotifiableRefToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :notifiable, polymorphic: true, null: false
  end
end
