require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test 'belongs to user' do
    notification = notifications(:friend_request_notification_user_one)
    user = notification.user

    assert_equal(user, users(:one))
  end

  test 'can belong to friend request as notifiable' do
    notification = notifications(:friend_request_notification_user_one)
    friend_request = notification.notifiable

    assert_equal(friend_request, friend_requests(:friend_request_five_one))
  end

  test 'can belong to like as notifiable' do
    notification = notifications(:like_notification_one_user_one)
    like = notification.notifiable

    assert_equal(like, likes(:like_one_post_one_user_three))
  end

  test 'can belong to comment as notifiable' do
    notification = notifications(:comment_notification_user_one)
    comment = notification.notifiable

    assert_equal(comment, comments(:comment_post_one_user_two))
  end

  test 'can belong to a group notification' do
    notification = notifications(:like_notification_one_user_one)
    group = notification.group

    assert_equal(group, notifications(:group_notification_likes))
  end

  test 'has many notifications as a group notification' do
    group_notification = notifications(:group_notification_likes)
    notifications = group_notification.notifications

    assert_includes(notifications, notifications(:like_notification_one_user_one))
    assert_includes(notifications, notifications(:like_notification_two_user_one))
  end
end
