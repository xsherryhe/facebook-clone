require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'belongs to user' do
    profile = profiles(:profile_user_one)
    user = users(:one)

    assert_equal(profile.user, user)
  end
end
