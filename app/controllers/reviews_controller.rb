class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :find_review, :authorize_user, except: [:index, :create]

  def index
    @reviews = Review.where(cocktail: get_cocktail)
  end

  def create
    @review = Review.new(strong_params)
    @review.user = current_user
    @review.cocktail = get_cocktail
    if @review.save
      redirect_to cocktail_path(@review.cocktail), notice: "Review posted!"
    else
      redirect_to request.referrer, alert: "Failed to post review: #{@review.errors.full_messages.join(' ')}"
    end
  end

  def edit
  end

  def update
  end

  def destroy
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

  def authorize_user
    if @review.user != current_user
      redirect_to cocktail_reviews_path(get_cocktail), alert: 'You are not authorized to change this review.'
    end
  end


  def strong_params
    params.require(:review).permit(:cocktail, :rating, :title, :text)
  end

end
