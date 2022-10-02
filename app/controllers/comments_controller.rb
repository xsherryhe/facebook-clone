class CommentsController < ApplicationController
  def index
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @turbo_frame = "#{@reactable_singular}-#{params[:reactable_id]}-comments-with-form"
    @reactable = @reactable_type.classify.constantize.find(params[:reactable_id])
    @page = params[:page]&.to_i
    @comments = @page ? @reactable.comments.up_to_page(@page) : @reactable.comments.preview
    @comment = @reactable.comments.build
  rescue NameError, ActiveRecord::RecordNotFound
    @error = 'Sorry, could not find comments.'
    render 'shared/error'
  end

  def create
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @turbo_frame = "#{@reactable_singular}-#{params[:reactable_id]}-comments-form"
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
    @turbo_frame = "comment-#{params[:id]}"
    @comment = Comment.find(params[:id])
    @reactable = @comment.reactable
    @page = @comment.comment_page
    handle_unauthorized('edit') unless @comment.user == current_user
  end

  def update
    @turbo_frame = "comment-#{params[:id]}"
    @comment = Comment.find(params[:id])
    return handle_unauthorized('edit') unless @comment.user == current_user

    if @comment.update(comment_params)
      render @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @turbo_frame = "comment-#{params[:id]}"
    @comment = Comment.find(params[:id])
    @comment_name = @comment.reactable.comment_name
    return handle_unauthorized('delete') unless @comment.user == current_user

    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, raw_photos: [], photos_attributes: %i[id _destroy])
  end
end
