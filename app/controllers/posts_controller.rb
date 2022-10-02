class PostsController < ApplicationController
  def index
    @page = params[:page]&.to_i || 1
    @posts = Post.where(creator: [current_user] + current_user.friends)
                 .includes(creator: { profile: { avatar: { stored_attachment: :blob } } },
                           photos: { stored_attachment: :blob },
                           comments: [{ user: :profile }, :comments, { photos: { stored_attachment: :blob } }],
                           likes: { user: :profile })
                 .order(updated_at: :desc)
    @posts_count = @posts.count
    @posts = @posts.up_to_page(@page)
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @profile = current_user.profile
    @post = current_user.created_posts.build
    @response_format = if params[:response_format] == 'turbo_stream' then nil
                       elsif params[:response_format] then params[:response_format]
                       else
                         :html
                       end
  end

  def create
    @profile = current_user.profile
    @post = current_user.created_posts.build(post_params)
    @response_format = params[:response_format]&.to_sym

    respond_to do |format|
      if @post.save
        format.turbo_stream
        format.html do
          flash[:notice] = 'Successfully created new post.'
          redirect_to posts_path
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @profile = current_user.profile
    @post = Post.find(params[:id])
    return handle_unauthorized('edit') unless @post.creator == current_user
  end

  def update
    @profile = current_user.profile
    @post = Post.find(params[:id])
    return handle_unauthorized('edit') unless @post.creator == current_user

    if @post.update(post_params)
      flash[:notice] = 'Successfully edited post.'
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @id = params[:id]
    @turbo_frame = "post-#{@id}"
    @post = Post.find(@id)
    return handle_unauthorized('delete') unless @post.creator == current_user

    @post.destroy
  rescue ActiveRecord::RecordNotFound
    # Do nothing
    # Could render an error here, but the user intends to destroy the object anyway
  end

  private

  def post_params
    params.require(:post).permit(:body, raw_photos: [], photos_attributes: %i[id _destroy])
  end
end
