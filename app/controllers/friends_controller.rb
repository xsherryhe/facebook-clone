class FriendsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def create
    @turbo_frame = "friend-request-#{params[:id]}"
    @friend = User.find(params[:id])
    @friend_requests = [[@friend, current_user], [current_user, @friend]]
                       .map { |sender, receiver| FriendRequest.find_by(sender:, receiver:) }
    @friend_request = @friend_requests.first
    unless @friend_request
      return handle_unauthorized('make', 
                                 additional_info: 'Please send a friend request first.',
                                 additional_info_link: @friend)
    end

    current_user.add_friend(@friend)
    @friend_requests.compact.each(&:accepted!)
  rescue ActiveRecord::RecordNotUnique
    current_user.errors.add(:friends, "You are already friends with #{@friend.profile.first_name}!")
  end

  def destroy
    @turbo_frame = "unfriend-#{params[:id]}"
    @friend = User.find(params[:id])
    # Do nothing if the user was not friends with the current user, allow the unfriend to go through
    # Alternatively, to render an error:
    # unless User.joins(:friends).exists?(friendships: { user_id: current_user.id, friend_id: @friend.id })
      # return handle_unauthorized('unfriend',
                                  # additional_info: "You weren't friends to begin with!",
                                  # error_persistent: true)
    # end

    current_user.remove_friend(@friend)
    FriendRequest.between(current_user, @friend).each(&:destroy)
  end
end
