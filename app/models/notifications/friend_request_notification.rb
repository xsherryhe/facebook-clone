class Notifications::FriendRequestNotification < Notification
  alias_attribute :friend_request, :notifiable

  def initiator
    friend_request.sender
  end

  def initiator_action
    'sent you a friend request'
  end

  def link
    friend_requests_path
  end

  def associations_for_includes
    { friend_request: { sender: :profile } }
  end

  private

  def set_user
    self.user = friend_request.receiver
  end
end
