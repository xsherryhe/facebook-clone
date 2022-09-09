class UsersController < ApplicationController
  def index
    # TO DO: Add params to filter by friends/pending friends or not friends, and header
    # TO DO: Add stored to avatar to avoid N + 1
    @users = User.includes(profile: :avatar)
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @profile = @user.profile
    @posts = @user.created_posts.includes(creator: :profile)
  end
end
