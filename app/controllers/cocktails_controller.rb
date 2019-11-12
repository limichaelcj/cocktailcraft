class CocktailsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_cocktail, only: [:show, :edit, :update, :destroy]

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

  def destroy
    if @cocktail.destroy
      redirect_to cocktails_path, notice: "#{@cocktail.name} recipe successfully deleted."
    else
      redirect_to :edit, alert: "Unable to delete #{@cocktail.name}: #{@cocktail.errors.full_messages.join(' ')}"
    end
  end

  def remix
    if request.post?
      @cocktail = Cocktail.find(params[:id])
      # prepare remix with new doses
      @remix = Cocktail.new(@cocktail.attributes.slice('name', 'description', 'photo', 'instructions'))
      @remix.name = "Remix of #{@remix.name}"
      @remix.user = current_user
      @doses = @cocktail.doses.map do |d|
        copy = Dose.new(d.attributes.slice('amount', 'ingredient_id', 'measurement_id'))
        copy.cocktail = @remix
        return copy
      end

      begin
        Cocktail.transaction do
          @remix.save!
          Dose.transaction do
            @doses.each { |d| d.save! }
          end
        end
        # successful saves, redirect to
        redirect_to edit_cocktail_path(@remix), notice: "Successfully remixed! Here in the lab, you can customize your new recipe."
      rescue ActiveRecord::RecordInvalid => invalid
        puts "\nSAVE ERROR\n"
        puts invalid.record.errors
        redirect_to :back, alert: "Failed to remix."
      end
    end
  end

  private

  def find_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def strong_params
    params.require(:cocktail).permit(:name, :description, :photo, :instructions)
  end

end
