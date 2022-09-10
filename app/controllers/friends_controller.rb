class FriendsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def create
    @friend = User.find(params[:id])
    @friend_request = FriendRequest.find_by(sender: @friend, receiver: current_user)
    unless @friend_request
      return unauthorized_redirect('make', strangers_path, additional_info: 'Please send a friend request first.')
    end

    current_user.add_friend(@friend)
    @friend_request.accepted!
    respond_to { |format| format.turbo_stream }
  end
end
