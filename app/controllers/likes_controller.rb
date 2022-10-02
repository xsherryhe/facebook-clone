class LikesController < ApplicationController
  before_action :set_reactable

  def create
    return if @error

    @likes = Like.where(reactable: @reactable)
    @like = current_user.likes.create(reactable: @reactable)
  rescue ActiveRecord::RecordNotUnique
    # Do nothing
  end

  def destroy
    return if @error

    @like = Like.find(params[:id])
    return unless @like.user == current_user

    @like.destroy
  rescue ActiveRecord::RecordNotFound
    # Do nothing
    # Could render an error here, but the user intends to destroy the object anyway
  end

  private

  def set_reactable
    @reactable_id = params[:reactable_id]
    @reactable_type = params[:reactable_type]
    @reactable_singular = @reactable_type.singularize
    @reactable = @reactable_type.classify.constantize.find(@reactable_id)
  rescue ActiveRecord::RecordNotFound
    @error = "This #{@reactable_singular} no longer exists."
  end
end
