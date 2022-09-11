require "test_helper"

class FriendFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'can view list of friends' do
    get friends_path
    assert_response :success
    assert_select 'a', 'FirstTwo MiddleTwo LastTwo'
    assert_select 'a', 'FirstThree LastThree'
  end

  test 'can view list of non-friend users to find friends' do
    get strangers_path
    assert_response :success
    assert_select 'a', 'FirstFour LastFour'
  end

  test 'can view pending friend requests' do
    get friend_requests_path
    assert_response :success
    assert_select 'p', text: 'FirstTwo MiddleTwo LastTwo send you a friend request.', count: 0
    assert_select 'p', 'FirstFive LastFive sent you a friend request.'
  end

  test 'can send friend request to other non-friend user which other user can view' do
    post friend_requests_path, params: { friend_request: { receiver_id: users(:one).id } }
    assert_response :unprocessable_entity
    assert_select 'p.error', 'You cannot send a friend request to yourself!'

    post friend_requests_path, params: { friend_request: { receiver_id: users(:six).id } }
    assert_response :unprocessable_entity
    assert_select 'p.error', 'You have already sent a friend request to FirstSix!'

    post friend_requests_path, params: { friend_request: { receiver_id: users(:two).id } }
    assert_response :unprocessable_entity
    assert_select 'p.error', 'You are already friends with FirstTwo!'

    post friend_requests_path, params: { friend_request: { receiver_id: users(:two).id } }
    assert_response :unprocessable_entity
    assert_select 'p.error', 'You are already friends with FirstTwo!'

    post friend_requests_path(format: :turbo_stream), params: { friend_request: { receiver_id: users(:four).id } }
    assert_response :success
    assert_select 'div', 'Friend request sent!'

    sign_in users(:four)
    get friend_requests_path
    assert_response :success
    assert_select 'p', 'FirstOne MiddleOne LastOne sent you a friend request.'
  end

  test 'can accept a friend request and view new friend on friends list' do
    post create_friend_path(users(:two))
    assert_equal("You don't have permission to make that friend. Please send a friend request first.", flash[:error])
    assert_response :redirect

    post create_friend_path(users(:four))
    assert_equal("You don't have permission to make that friend. Please send a friend request first.", flash[:error])
    assert_response :redirect

    post create_friend_path(users(:five), format: :turbo_stream)
    assert_response :success
    assert_select 'div', "Success! You're friends now."

    get friends_path
    assert_response :success
    assert_select 'a', 'FirstFive LastFive'
  end

  test 'can delete received friend requests' do
    delete friend_request_path(friend_requests(:friend_request_two_four))
    assert_equal("You don't have permission to delete that friend request.", flash[:error])
    assert_response :redirect

    delete friend_request_path(friend_requests(:friend_request_five_one), format: :turbo_stream)
    assert_response :success
    assert_select 'div', 'Successfully deleted friend request.'
  end
end
