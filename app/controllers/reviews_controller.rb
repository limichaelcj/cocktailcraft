class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :find_review, except: [:index, :create]

  after_action :verify_authorized, except: [:index, :create]

  def index
    @reviews = Review.where(cocktail: get_cocktail)
  end

  def create
    puts params
    @review = Review.new(strong_params)
    @review.user = current_user
    @review.cocktail = get_cocktail
    if @review.save
      redirect_to cocktail_path(@review.cocktail), notice: "Review posted!"
    else
      redirect_back fallback_location: cocktail_path(@review.cocktail), alert: "Failed to post review: #{@review.errors.full_messages.join(' ')}"
    end
  end

  def edit
    authorize @review
  end

  def update
    authorize @review
  end

  def destroy
    authorize @review
    if @review.destroy
      cocktail = get_cocktail
      redirect_to cocktail_path(cocktail), notice: "Your review for #{cocktail.name} was removed."
    else
      redirect_to request.referrer, alert: "Failed to delete review: #{@review.errors.full_messages.join(' ')}"
    end
  end

  private

  def get_cocktail
    Cocktail.find(params[:cocktail_id])
  end

  def find_review
    @review = Review.find(params[:id])
  end

  def strong_params
    params.require(:review).permit(:cocktail, :rating, :title, :text)
  end

end
