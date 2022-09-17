require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'has one profile' do
    user = users(:one)
    profile = profiles(:profile_user_one)

    assert_equal(user.profile, profile)
  end

  test 'has many sent friend requests' do
    user = users(:two)
    sent_friend_requests = user.sent_friend_requests

    assert_includes(sent_friend_requests, friend_requests(:friend_request_two_four))
  end

  test 'has many received friend requests' do
    user = users(:three)
    received_friend_requests = user.received_friend_requests

    assert_includes(received_friend_requests, friend_requests(:friend_request_four_three))
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

  test 'has many created posts' do
    user = users(:one)
    posts = user.created_posts

    assert_includes(posts, posts(:post_one_from_user_one))
    assert_includes(posts, posts(:post_two_from_user_one))
  end

  test 'has many likes' do
    user = users(:three)
    likes = user.likes

    assert_includes(likes, likes(:like_one_post_one_user_three))
  end

  test 'has many comments' do
    user = users(:two)
    comments = user.comments

    assert_includes(comments, comments(:comment_post_one_user_two))
  end

  test 'has many photos' do
    user = users(:two)
    photos = user.photos

    assert_includes(photos, images(:avatar_user_two))
  end
end
