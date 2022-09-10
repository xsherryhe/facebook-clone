class UsersController < ApplicationController
  def index
    @is_friend = params[:is_friend]
    @users = (@is_friend ? current_user.friends : current_user.strangers)
             .includes(profile: { avatar: :stored_attachment })
    @heading_word = @is_friend ? 'My' : 'Find'
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @profile = @user.profile
    @posts = @user.created_posts.includes(creator: :profile)
  end
end
