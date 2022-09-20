class UsersController < ApplicationController
  def index
    @users = current_user.strangers.includes({ profile: { avatar: :stored_attachment } })
    @sent_friend_requests = current_user.sent_friend_requests.pending.includes(:receiver)
    @received_friend_requests = current_user.received_friend_requests.pending.includes(sender: :profile)
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @profile = @user.profile
    @posts = @user.created_posts.includes(creator: :profile)
  end
end
