require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'has one profile' do
    user = users(:one)
    profile = profiles(:profile_user_one)

    assert_equal(user.profile, profile)
  end

  test 'has many created posts' do
    user = users(:one)
    posts = user.created_posts

    assert_includes(posts, posts(:post_one_from_user_one))
    assert_includes(posts, posts(:post_two_from_user_one))
  end

  test 'has many sent friend requests' do
    user = users(:three)
    sent_friend_requests = user.sent_friend_requests

    assert_includes(sent_friend_requests, friend_requests(:friend_request_three_one))
  end

  test 'has many received friend requests' do
    user = users(:two)
    received_friend_requests = user.received_friend_requests

    assert_includes(received_friend_requests, friend_requests(:friend_request_one_two))
  end

  test 'has many friends' do
    user = users(:one)
    friends = user.friends

    assert_includes(friends, users(:two))
    assert_includes(friends, users(:three))
  end

  test 'belongs to many friends' do
    user = users(:one)
    friend_a = users(:two)
    friend_b = users(:three)

    assert_includes(friend_a.friends, user)
    assert_includes(friend_b.friends, user)
  end
end
