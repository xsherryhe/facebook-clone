class UsersController < ApplicationController
  def index
    # TO DO: Add params to filter by friends/pending friends or not friends, and header
    @users = User.includes(:profile)
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @profile = @user.profile
    @posts = @user.created_posts.includes(creator: :profile)
  end
end
