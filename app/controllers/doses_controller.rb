class DosesController < ApplicationController

  def create
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = Dose.new(strong_params)

    # get ingredient
    ingredient_input = params[:ingredient].strip.downcase.singularize
    ingredient = identify_ingredient(ingredient_input)

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

    # response formatting routes
    respond_to do |format|
      format.html { redirect_to edit_cocktail_path(@cocktail), flash: { errors: @errors } }
      format.js
      if @errors
        format.json { render json: @errors, status: :unprocessable_entity }
      else
        format.json { render json: @dose, status: :created }
      end
    end
  end

  private

  def strong_params
    tmp = params.require(:dose).permit(:amount, :measurement_id)
    if tmp[:measurement_id] == 'none'
      tmp.delete(:measurement_id)
    end
    return tmp
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
