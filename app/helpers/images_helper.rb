module ImagesHelper
  def reaction_target(image)
    image.single_in_post? ? image.imageable : image
  end
end
