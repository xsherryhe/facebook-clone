require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
  test 'belongs to sender' do
    friend_request = friend_requests(:friend_request_one_two)
    sender = friend_request.sender

    assert_equal(sender, users(:one))
  end

  test 'belongs to receiver' do
    friend_request = friend_requests(:friend_request_three_one)
    receiver = friend_request.receiver

    assert_equal(receiver, users(:one))
  end
end
