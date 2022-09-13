require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test 'belongs to user' do
    comment = comments(:comment_post_one_user_two)
    user = comment.user

    assert_equal(user, users(:two))
  end

  test 'can belong to post as reactable' do
    comment = comments(:comment_post_one_user_two)
    reactable = comment.reactable

    assert_equal(reactable, posts(:post_one_from_user_one))
  end

  test 'can belong to comment as reactable' do
    comment = comments(:comment_comment_one_user_four)
    reactable = comment.reactable

    assert_equal(reactable, comments(:comment_post_one_user_two))
  end

  test 'has many likes' do
    comment = comments(:comment_comment_one_user_four)
    likes = comment.likes

    assert_includes(likes, likes(:like_two_comment_two_user_five))
  end

  test 'has many comments' do
    comment = comments(:comment_post_one_user_two)
    comments = comment.comments

    assert_includes(comments, comments(:comment_comment_one_user_four))
  end
end
