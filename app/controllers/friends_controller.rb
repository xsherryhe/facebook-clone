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
    NotificationsChannel.broadcast_to(@friend, {})
  rescue ActiveRecord::RecordNotUnique
    current_user.errors.add(:friends, "You are already friends with #{@friend.profile.first_name}!")
  end

  def destroy
    @friend = User.find(params[:id])
    unless User.joins(:friends).exists?(friendships: { user_id: current_user.id, friend_id: @friend.id })
      return unauthorized_redirect('unfriend', @friend, additional_info: 'You were never friends to begin with!')
    end

    current_user.remove_friend(@friend)
    FriendRequest.between(current_user, @friend).each(&:destroy)
  end
end
