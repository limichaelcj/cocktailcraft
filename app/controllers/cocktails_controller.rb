class CocktailsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_cocktail, only: [:show, :edit, :update]

  def index
    @cocktails = Cocktail.all
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(strong_params)
    @cocktail.user = current_user
    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  def edit
    @dose = Dose.new
    @measurements = Measurement.all
  end

  def update
    flash = !strong_params.empty? && @cocktail.update(strong_params) ? { notice: 'Update success!' } : { alert: 'Update failed.' }
    redirect_to edit_cocktail_path(@cocktail), flash
  end

  private

  def find_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def strong_params
    params.require(:cocktail).permit(:name, :description, :photo, :instructions)
  end

end
