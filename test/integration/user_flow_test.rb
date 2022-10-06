require "test_helper"

class UserFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can view user's own profile" do
    get current_user_path
    assert_response :success
    assert_select 'h1', 'FirstOne MiddleOne LastOne'
    assert_select 'div.post-body', 'PostOneBody'
    assert_select 'div.post-body', text: 'PostThreeBody', count: 0
  end

  test "can view another user's public profile" do
    get user_path(users(:two))
    assert_response :success
    assert_select 'h1', 'FirstTwo MiddleTwo LastTwo'
    assert_select 'div.birthdate', 'Birthday: February 26, 1985'
    assert_select 'div.location', 'Location: Two, California'
    assert_select 'div.post-body', 'PostThreeBody'
    assert_select 'div.post-body', text: 'PostOneBody', count: 0

    get user_path(users(:three))
    assert_response :success
    assert_select 'h1', 'FirstThree LastThree'
    assert_select 'div.birthdate', count: 0
    assert_select 'div.location', count: 0
  end
end
