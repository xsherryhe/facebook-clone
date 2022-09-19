require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
  test 'belongs to sender' do
    friend_request = friend_requests(:friend_request_five_four)
    sender = friend_request.sender

    assert_equal(sender, users(:five))
  end

  test 'belongs to receiver' do
    friend_request = friend_requests(:friend_request_four_three)
    receiver = friend_request.receiver

    assert_equal(receiver, users(:three))
  end
end
