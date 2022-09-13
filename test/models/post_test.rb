require "test_helper"

class PostTest < ActiveSupport::TestCase
  test 'belongs to creator' do
    post = posts(:post_three_from_user_two)
    user = post.creator

    assert_equal(user, users(:two))
  end

  test 'has many likes' do
    post = posts(:post_one_from_user_one)
    likes = post.likes

    assert_includes(likes, likes(:like_one_post_one_user_three))
  end

  test 'has many comments' do
    post = posts(:post_one_from_user_one)
    comments = post.comments

    assert_includes(comments, comments(:comment_post_one_user_two))
  end
end
