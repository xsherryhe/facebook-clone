class AddViewStatusToFriendRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :friend_requests, :view_status, :integer, default: 0
  end
end
