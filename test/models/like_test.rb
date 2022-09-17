require "test_helper"

class LikeTest < ActiveSupport::TestCase
  test 'belongs to user' do
    like = likes(:like_one_post_one_user_three)
    user = like.user

    assert_equal(user, users(:three))
  end

  test 'can belong to post as reactable' do
    like = likes(:like_one_post_one_user_three)
    reactable = like.reactable

    assert_equal(reactable, posts(:post_one_from_user_one))
  end

  test 'can belong to comment as reactable' do
    like = likes(:like_two_comment_two_user_five)
    reactable = like.reactable

    assert_equal(reactable, comments(:comment_comment_one_user_four))
  end

  test 'can belong to image as reactable' do
    like = likes(:like_five_photo_seven_user_two)
    reactable = like.reactable

    assert_equal(reactable, images(:photo_post_one))
  end
end
