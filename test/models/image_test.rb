require "test_helper"

class ImageTest < ActiveSupport::TestCase
  test 'can belong to profile as imageable' do
    avatar = images(:avatar_user_one)
    profile = avatar.imageable

    assert_equal(profile, profiles(:profile_user_one))
  end
end
