class CommentsController < ApplicationController
  before_action :set_reactable_and_turbo_frame

  def index
    @page = params[:page]&.to_i
    @comments = @page ? @reactable.comments.up_to_page(@page) : @reactable.comments.preview
    @comment = @reactable.comments.build
  end

  def create
    return if @error

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
    @back_route = comments_path(@reactable.model_name.route_key, @reactable, page: @page)
    handle_unauthorized('edit', back_route: @back_route) unless @comment.user == current_user
  end

  def update
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user
      back_route = comments_path(@reactable.model_name.route_key, @reactable, page: @comment.comment_page)
      return handle_unauthorized('edit', back_route:)
    end

    if @comment.update(comment_params)
      render @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user
      back_route = comments_path(@reactable.model_name.route_key, @reactable, page: @comment.comment_page)
      return handle_unauthorized('delete', back_route:)
    end

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
  rescue NameError, ActiveRecord::RecordNotFound => e
    handle_not_found_reactable(e)
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

  def handle_not_found_reactable(exception)
    @error = if exception.is_a?(NameError)
               'Sorry, could not find comments.'
             else
               "This #{@reactable_singular} and its #{@comment_name.pluralize} no longer exist."
             end
    handle_not_found(exception) unless action_name == 'create'
  end
end
