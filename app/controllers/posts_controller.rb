class PostsController < ApplicationController
  def index
    @posts = Post.includes(creator: :profile).order(updated_at: :desc)
    @user = current_user
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
    return unauthorized_redirect('edit') unless @post.creator == current_user
  end

  def update
    @profile = current_user.profile
    @post = Post.find(params[:id])
    return unauthorized_redirect('edit') unless @post.creator == current_user

    if @post.update(post_params)
      flash[:notice] = 'Successfully edited post.'
      redirect_to posts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    return unauthorized_redirect('delete') unless @post.creator == current_user

    @post.destroy
    flash[:notice] = 'Successfully deleted post.'
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def unauthorized_redirect(action)
    flash[:error] = "You don't have permission to #{action} that post."
    redirect_to posts_path
  end
end
