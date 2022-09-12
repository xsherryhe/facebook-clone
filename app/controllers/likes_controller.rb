class LikesController < ApplicationController
  def create
    @reactable_id = params[:reactable_id]
    @reactable_type = params[:reactable_type]
    @reactable_class = @reactable_type.classify
    @reactable_singular = @reactable_type.singularize
    @likes = Like.where(reactable_type: @reactable_class, reactable_id: @reactable_id)
    begin
      @like = current_user.likes.create(reactable_type: @reactable_class, reactable_id: @reactable_id)
    rescue ActiveRecord::RecordNotUnique
      # do nothing
    end
  end

  def destroy
    @like = Like.find(params[:id])
    return unless @like.user == current_user

    @reactable = @like.reactable
    @reactable_type = @like.reactable_type.downcase
    @like.destroy
  end
end
