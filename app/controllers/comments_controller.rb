class CommentsController < ApplicationController
  before_action :set_reactable_and_turbo_frame

  def index
    @page = params[:page]&.to_i
    @comments = @page ? @reactable.comments.up_to_page(@page) : @reactable.comments.preview
    @comment = @reactable.comments.build
  rescue NameError
    @error = 'Sorry, could not find comments.'
    render 'shared/error'
  end

  def create
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
    @page = @comment.comment_page
    handle_unauthorized('edit') unless @comment.user == current_user
  end

  def update
    @comment = Comment.find(params[:id])
    return handle_unauthorized('edit') unless @comment.user == current_user

    if @comment.update(comment_params)
      render @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    return handle_unauthorized('delete') unless @comment.user == current_user

    @comment.destroy
  rescue ActiveRecord::RecordNotFound
    # Do nothing
    # Could render an error here, but the user intends to destroy the object anyway
  end

  private

  def set_reactable_and_turbo_frame
    @reactable_id = params[:reactable_id]
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable_model = @reactable_type.classify.constantize
    @comment_name = @reactable_model.new.comment_name

    set_turbo_frame
    @reactable = @reactable_model.find(@reactable_id)
  rescue ActiveRecord::RecordNotFound => e
    @error = "This #{@reactable_singular} and its #{@comment_name.pluralize} no longer exist."
    handle_not_found(e)
  end

  def set_turbo_frame
    @turbo_frame = case action_name
                   when 'index' then "#{@reactable_singular}-#{@reactable_id}-comments-with-form"
                   when 'create' then "#{@reactable_singular}-#{@reactable_id}-comments-form"
                   else "comment-#{params[:id]}"
                   end
  end

  def comment_params
    params.require(:comment).permit(:body, raw_photos: [], photos_attributes: %i[id _destroy])
  end
end
