class FriendRequestsController < ApplicationController
  def index
    @friend_requests = current_user.received_friend_requests
                                   .pending
                                   .includes(sender: :profile)
    @friend_requests.each(&:friend_request_viewed!)
  end

  def create
    @receiver_id = params[:receiver_id]
    @turbo_frame = "friend-request-form-#{@receiver_id}"
    @receiver = User.find(@receiver_id)
    @friend_request = current_user.sent_friend_requests.build(receiver: @receiver)
    render :new, status: :unprocessable_entity unless @friend_request.save
  rescue ActiveRecord::RecordNotUnique
    @friend_request.errors.add(:base, 'You have already sent a friend request to ' \
                                      "#{@friend_request.receiver.profile.first_name}!")
    render :new, status: :unprocessable_entity
  end

  def destroy
    @friend_id = params[:friend_id]
    @turbo_frame = "friend-request-#{@friend_id}"
    @friend_request = FriendRequest.find(params[:id])
    return handle_unauthorized('delete', friend_requests_path) unless @friend_request.receiver == current_user

    if User.joins(:friends).exists?(friendships: { user_id: current_user.id, friend_id: @friend_id })
      @friend_request.accepted!
    else
      @friend_request.destroy
    end
  rescue ActiveRecord::RecordNotFound
    # Do nothing
    # Could render an error here, but the user intends to destroy the object anyway
  end
end
