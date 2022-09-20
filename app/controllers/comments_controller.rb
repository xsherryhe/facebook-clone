class CommentsController < ApplicationController
  def index
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable = @reactable_type.classify.constantize.find(params[:reactable_id])
    @page = params[:page]&.to_i
    @comments = @page ? @reactable.comments.up_to_page(@page) : @reactable.comments.preview
    @comment = @reactable.comments.build
  rescue NameError, ActiveRecord::RecordNotFound
    flash[:error] = 'Sorry, could not find comments.'
    redirect_to posts_path
  end

  def create
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable = @reactable_type.classify.constantize.find(params[:reactable_id])
    @comment = current_user.comments.build(comment_params.merge(reactable: @reactable))

    respond_to do |format|
      if @comment.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    return unauthorized_redirect('edit', posts_path) unless @comment.user == current_user
  end

  def update
    @comment = Comment.find(params[:id])
    return unauthorized_redirect('edit', posts_path) unless @comment.user == current_user

    if @comment.update(comment_params)
      render @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @id = params[:id]
    @comment = Comment.find(@id)
    @comment_name = @comment.reactable.comment_name
    return unauthorized_redirect('delete', posts_path) unless @comment.user == current_user

    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, raw_photos: [])
  end
end
