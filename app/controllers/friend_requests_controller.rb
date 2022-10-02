class FriendRequestsController < ApplicationController
  def index
    @friend_requests = current_user.received_friend_requests
                                   .pending
                                   .includes(sender: :profile)
    @friend_requests.each(&:friend_request_viewed!)
  end

  def create
    @friend_request = current_user.sent_friend_requests.build(friend_request_params)
    render :new, status: :unprocessable_entity unless @friend_request.save
  rescue ActiveRecord::RecordNotUnique
    @friend_request.errors.add(:base, 'You have already sent a friend request to ' \
                                      "#{@friend_request.receiver.profile.first_name}!")
    render :new, status: :unprocessable_entity
  end

  def destroy
    @turbo_frame = "friend-request-#{params[:friend_id]}"
    @friend_request = FriendRequest.find(params[:id])
    return handle_unauthorized('delete', friend_requests_path) unless @friend_request.receiver == current_user

    @friend_request.destroy
  rescue ActiveRecord::RecordNotFound
    # Do nothing
    # Could render an error here, but the user intends to destroy the object anyway
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end
end
