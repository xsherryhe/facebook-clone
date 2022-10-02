class LikesController < ApplicationController
  def create
    @reactable_id = params[:reactable_id]
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable = @reactable_type.classify.constantize.find(@reactable_id)
    @likes = Like.where(reactable: @reactable)
    @like = current_user.likes.create(reactable: @reactable)
  rescue ActiveRecord::RecordNotUnique
    # Do nothing
  rescue ActiveRecord::RecordNotFound
    @error = "Sorry, #{@reactable_singular} deleted."
  end

  def destroy
    @reactable_id = params[:reactable_id]
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable = @reactable_type.classify.constantize.find(@reactable_id)
    @like = Like.find(params[:id])
    return unless @like.user == current_user

    @like.destroy
  rescue ActiveRecord::RecordNotFound => e
    @error = "Sorry, #{e.model.downcase} deleted." unless e.model == 'Like'
  end
end
