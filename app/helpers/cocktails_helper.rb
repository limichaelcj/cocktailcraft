module CocktailsHelper

  def cocktail_creator(instance)
    instance.user.nil? ? 'Classic Collection' : instance.user.name
  end

  def cocktail_image_path(instance)
    cl_image_path(instance.photo.nil? ? 'cocktail.jpg' : instance.photo)
  end

end
