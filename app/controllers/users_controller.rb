class UsersController < ApplicationController
  def index
    @users = current_user.strangers.includes({ profile: { avatar: { stored_attachment: :blob } } }).limit(50)
    @sent_friend_requests = current_user.sent_friend_requests.pending.includes(:receiver)
    @received_friend_requests = current_user.received_friend_requests.pending.includes(sender: :profile)
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @profile = @user.profile

    @posts_page = params[:posts_page]&.to_i || 1
    @posts = @user.created_posts
                  .includes(creator: { profile: { avatar: { stored_attachment: :blob } } },
                            photos: { stored_attachment: :blob },
                            comments: [{ user: :profile }, :comments, { photos: { stored_attachment: :blob } }],
                            likes: { user: :profile })
                  .order(updated_at: :desc)
    @posts_count = @posts.count
    @posts = @posts.up_to_page(@posts_page)

    @photos_page = params[:photos_page]&.to_i || 1
    @photos = @user.photos.with_attached_stored.order(updated_at: :desc)
    @photos_count = @photos.count
    @photos = @photos.on_page(@photos_page)
  end
end
