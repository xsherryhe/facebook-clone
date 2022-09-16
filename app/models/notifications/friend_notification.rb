class Notifications::FriendNotification < Notification
  alias_attribute :friend_request, :notifiable

  def initiator
    friend_request.receiver
  end

  def initiator_action
    'accepted your friend request'
  end

  def link
    user_path(friend_request.receiver)
  end

  def associations_for_includes
    { friend_request: { receiver: :profile } }
  end

  private

  def set_user
    self.user = friend_request.sender
  end
end
