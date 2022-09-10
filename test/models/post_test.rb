require "test_helper"

class PostTest < ActiveSupport::TestCase
  test 'belongs to creator' do
    post = posts(:post_three_from_user_two)
    user = post.creator

    assert_equal(user, users(:two))
  end
end
