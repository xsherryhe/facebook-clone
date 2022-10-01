module ApplicationHelper
  def mini_avatar(profile, link_path = user_path(profile.user))
    render profile.avatar, link_path:, size: '40'
  end

  def full_avatar(profile, link_path = image_path(profile.avatar))
    render profile.avatar, link_path:, size: '250'
  end

  def friend_request_link
    requests = current_user.new_friend_requests
    link_to "Friend Requests#{requests.any? ? " (#{requests.size})" : ''}",
            friend_requests_path,
            class: requests.any? ? 'important-link' : nil
  end

  def notifications_link
    new_notifications = current_user.notifications.for_display.notification_unviewed
    link_to "Notifications#{new_notifications.any? ? " (#{new_notifications.size})" : ''}",
            notifications_path,
            data: { turbo_frame: 'notifications',
                    action: 'viewed#setToViewed hidden#toggleHidden' },
            class: new_notifications.any? ? 'notifications-link important-link' : 'notifications-link'
  end
end
