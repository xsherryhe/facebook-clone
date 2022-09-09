require "test_helper"

class UserFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can view user's own profile" do
    get current_user_path
    assert_response :success
    assert_select 'h3', 'FirstOne MiddleOne LastOne'
    assert_select 'div.birthdate', 'Birthday: August 23, 1990'
    assert_select 'div.location', 'Location: One, Wisconsin'
    assert_select 'div.body', 'PostOneBody'
    assert_select 'div.body', text: 'PostThreeBody', count: 0
  end

  test "can view another user's profile" do
    get user_path(users(:two))
    assert_response :success
    assert_select 'h3', 'FirstTwo MiddleTwo LastTwo'
    assert_select 'div.location', 'Location: Two, California'
    assert_select 'div.body', 'PostThreeBody'
    assert_select 'div.body', text: 'PostOneBody', count: 0
  end

  test 'can view list of other users' do
    get users_path
    assert_response :success
    assert_select 'a', 'FirstTwo MiddleTwo LastTwo'
    assert_select 'a', 'FirstThree LastThree'
  end
end
