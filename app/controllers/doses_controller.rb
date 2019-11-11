class DosesController < ApplicationController

  def create
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = Dose.new(strong_params)

    # get ingredient
    ingredient = identify_ingredient(params[:ingredient].strip.downcase.pluralize(1))

    if ingredient
      @dose.ingredient = ingredient
      @dose.cocktail = @cocktail

      @dose.save
      if @dose.errors
        @errors = @dose.errors
      end
    else
      @errors = ingredient.errors
    end

    redirect_to edit_cocktail_path(@cocktail), flash: { errors: @errors }
  end

  private

  def strong_params
    params.require(:dose).permit(:amount, :measurement_id)
  end

  def identify_ingredient(name)
    requested = Ingredient.find_by(name: name)

    return requested if requested
    # requested not found -> create new ingredient

    new_ingredient = Ingredient.new(name: name)
    if new_ingredient.save
      return new_ingredient
    else
      return nil
    end
  end

end
