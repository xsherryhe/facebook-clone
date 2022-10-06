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
    assert_select '.friend-request-message', text: 'FirstTwo MiddleTwo LastTwo send you a friend request.', count: 0
    assert_select '.friend-request-message', 'FirstFive LastFive sent you a friend request.'
  end

  test 'can send friend request to other non-friend user which other user can view' do
    post friend_requests_path, params: { receiver_id: users(:one).id }
    assert_response :unprocessable_entity
    assert_select '.error', 'You cannot send a friend request to yourself!'

    post friend_requests_path, params: { receiver_id: users(:six).id }
    assert_response :unprocessable_entity
    assert_select '.error', 'You have already sent a friend request to FirstSix!'

    post friend_requests_path, params: { receiver_id: users(:two).id }
    assert_response :unprocessable_entity
    assert_select '.error', 'You are already friends with FirstTwo!'

    post friend_requests_path, params: { receiver_id: users(:two).id }
    assert_response :unprocessable_entity
    assert_select '.error', 'You are already friends with FirstTwo!'

    post friend_requests_path, params: { receiver_id: users(:four).id }
    assert_response :success
    assert_select 'div', 'Friend request sent!'

    sign_in users(:four)
    get friend_requests_path
    assert_response :success
    assert_select '.friend-request-message', 'FirstOne MiddleOne LastOne sent you a friend request.'
  end

  test 'can accept a friend request and view new friend on friends list' do
    post friend_path(users(:two))
    assert_select '.error', /You are already friends with FirstTwo!/

    post friend_path(users(:four))
    assert_select '.error', /You don't have permission to make that friend\./
    assert_select '.error', /Please send a friend request first\./

    post friend_path(users(:five))
    assert_response :success
    assert_select '.friend-message', /Success! You're friends now\./

    get friends_path
    assert_response :success
    assert_select 'a', 'FirstFive LastFive'
  end

  test 'can delete received friend requests' do
    delete friend_friend_request_path(users(:five), friend_requests(:friend_request_five_four))
    assert_select '.error', /You don't have permission to delete that friend request\./

    delete friend_friend_request_path(users(:five), friend_requests(:friend_request_five_one))
    assert_response :success
    assert_select 'div', 'Successfully deleted friend request.'
  end

  test 'can unfriend a friend' do
    delete friend_path(users(:four))
    assert_select 'div', 'Unfriended FirstFour.'

    delete friend_path(users(:two))
    assert_response :success
    assert_select 'div', 'Unfriended FirstTwo.'
  end
end
