class RemoveBodyFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :body, :text
  end
end
