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
end
