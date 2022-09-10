class UsersController < ApplicationController
  def index
    @users = current_user.strangers.includes(profile: { avatar: :stored_attachment })
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @profile = @user.profile
    @posts = @user.created_posts.includes(creator: :profile)
  end
end
