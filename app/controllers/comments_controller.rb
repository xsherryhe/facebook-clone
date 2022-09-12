class CommentsController < ApplicationController
  def index
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable = @reactable_type.classify.constantize.find(params[:reactable_id])
    @comments = @reactable.comments.includes(:comments)
    @comment = @reactable.comments.build
  rescue NameError, ActiveRecord::RecordNotFound
    flash[:error] = 'Sorry, could not find comments.'
    redirect_to posts_path
  end

  def create
    @reactable_id = params[:reactable_id]
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @comment = current_user.comments.build(comment_params.merge(reactable_type: @reactable_type.classify,
                                                                reactable_id: @reactable_id))

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
    @comment = Comment.find(params[:id])
    return unauthorized_redirect('delete', posts_path) unless @comment.user == current_user

    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
