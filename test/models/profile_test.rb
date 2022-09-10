require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  test 'belongs to user' do
    profile = profiles(:profile_user_one)
    user = users(:one)

    assert_equal(profile.user, user)
  end

  test 'has one avatar' do
    profile = profiles(:profile_user_two)
    avatar = profile.avatar

    assert_equal(avatar, images(:avatar_user_two))
  end
end
