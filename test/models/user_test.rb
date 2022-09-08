require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
end
