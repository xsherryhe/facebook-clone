class AddSenderRefAndReceiverRefToFriendRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :friend_requests, :sender, null: false, foreign_key: { to_table: :users }
    add_reference :friend_requests, :receiver, null: false, foreign_key: { to_table: :users }
  end
end
