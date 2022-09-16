class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.text :body
      t.integer :view_status, default: 0

      t.timestamps
    end
  end
end
