class FriendRequestsController < ApplicationController
  def index
    @friend_requests = current_user.received_friend_requests
                                   .pending
                                   .includes(sender: :profile)
  end

  def create
    @friend_request = current_user.sent_friend_requests.build(friend_request_params)
    respond_to do |format|
      begin
        if @friend_request.save
          format.turbo_stream
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        @friend_request.errors.add(:base, "You have already sent a friend request to #{@friend_request.receiver.profile.first_name}!")
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend = @friend_request.sender
    return unauthorized_redirect('delete', friend_requests_path) unless @friend_request.receiver == current_user

    @friend_request.destroy
    respond_to { |format| format.turbo_stream }
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end
end
