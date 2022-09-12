class FriendsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def create
    @friend = User.find(params[:id])
    @friend_request = FriendRequest.find_by(sender: @friend, receiver: current_user)
    unless @friend_request&.pending?
      return unauthorized_redirect('make', strangers_path, additional_info: 'Please send a friend request first.')
    end

    current_user.add_friend(@friend)
    @friend_request.accepted!
  rescue ActiveRecord::RecordNotUnique
    current_user.errors.add(:friends, "You are already friends with #{@friend.profile.first_name}!")
  end
end
