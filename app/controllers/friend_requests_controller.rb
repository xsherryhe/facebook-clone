class FriendRequestsController < ApplicationController
  def index
    @friend_requests = current_user.received_friend_requests
                                   .pending
                                   .includes(sender: :profile)
    @friend_requests.each(&:friend_request_viewed!)
  end

  def create
    @friend_request = current_user.sent_friend_requests.build(friend_request_params)
    if @friend_request.save
      NotificationsChannel.broadcast_to(@friend_request.receiver, {})
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @friend_request.errors.add(:base, 'You have already sent a friend request to ' \
                                      "#{@friend_request.receiver.profile.first_name}!")
    render :new, status: :unprocessable_entity
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend = @friend_request.sender
    return unauthorized_redirect('delete', friend_requests_path) unless @friend_request.receiver == current_user

    @friend_request.destroy
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end
end
