class DosesController < ApplicationController

  after_action :verify_authorized

  def create
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = Dose.new(strong_params)
    @dose.cocktail = @cocktail
    authorize @dose

    puts params
    puts params[:ingredient]

    # get ingredient
    ingredient_input = params.require(:dose)[:ingredient].strip.downcase.singularize
    ingredient = identify_ingredient(ingredient_input)

    if ingredient.errors.any?
      errors = ingredient.errors
    else
      @dose.ingredient = ingredient
      @dose.save
      if @dose.errors
        @errors = @dose.errors
      end
    end

    respond_to do |format|
      format.js
      if errors
        format.html { redirect_to edit_cocktail_path(@cocktail), notice: "Dose added to #{@cocktail.name}." }
      else
        format.html { redirect_to edit_cocktail_path(@cocktail), alert: "Dose could not be added: #{errors.join(' ')}" }
      end
    end
  end

  def destroy
    @dose = Dose.find(params[:id])
    authorize @dose

    respond_to do |format|
      if @dose.destroy
        format.html { redirect_to edit_cocktail_path(@dose.cocktail), notice: "Dose of \"#{@dose.ingredient.name}\" removed." }
      else
        format.html { redirect_to edit_cocktail_path(@dose.cocktail), alert: "Dose could not be removed: #{@dose.errors.full_messages.join(' ')}" }
      end
      format.js
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
    new_ingredient.save
    return new_ingredient
  end

end
