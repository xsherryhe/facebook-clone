class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])
    @image_container_id =
      if @image.single_in_post?
        imageable = @image.imageable
        "#{imageable.model_name.singular}-#{imageable.id}"
      else
        "image-#{@image.id}"
      end
  end
end
