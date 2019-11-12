class IngredientsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @ingredients = Ingredient.all.sort_by { |ing| -ing.recipes.count }
  end
end
