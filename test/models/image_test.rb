require "test_helper"

class ImageTest < ActiveSupport::TestCase
  test 'belongs to user' do
    avatar = images(:avatar_user_one)
    user = avatar.user

    assert_equal(user, users(:one))
  end

  test 'can belong to profile as imageable' do
    avatar = images(:avatar_user_one)
    profile = avatar.imageable

    assert_equal(profile, profiles(:profile_user_one))
  end

  test 'can belong to post as imageable' do
    photo = images(:photo_post_one)
    post = photo.imageable

    assert_equal(post, posts(:post_one_from_user_one))
  end

  test 'can belong to comment as imageable' do
    photo = images(:photo_comment_one)
    comment = photo.imageable

    assert_equal(comment, comments(:comment_post_one_user_two))
  end

  test 'has many likes' do
    image = images(:photo_post_one)
    likes = image.likes

    assert_includes(likes, likes(:like_five_photo_seven_user_two))
  end

  test 'has many comments' do
    image = images(:photo_post_one)
    comments = image.comments

    assert_includes(comments, comments(:comment_photo_seven_user_three))
  end
end
