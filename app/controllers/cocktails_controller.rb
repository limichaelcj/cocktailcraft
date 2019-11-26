class CocktailsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_cocktail, only: [:show, :edit, :update, :publish, :destroy, :mark]

  after_action :verify_authorized, only: [:edit, :update, :publish, :destroy]
  after_action :verify_policy_scoped, only: :index

  def index
    @search_page, @custom_page = params[:search_page] || 1, params[:custom_page] || 1
    @search_id, @custom_id = 'cocktail-search', 'cocktail-custom'

    # on html or ajax requests
    @cocktails = policy_scope(Cocktail)
    @classic = @cocktails.where(user: nil)
    @custom = @cocktails.where('user_id IS NOT NULL').paginate(page: @custom_page, per_page: cards_pp)
    if params[:search]
      @search_query = params[:search].downcase
      @search_results = Cocktail.search_keyword(@search_query).paginate(page: @search_page, per_page: items_pp)
    end

    # on ajax requests only
    if request.xhr?
      # determine change in search params
      prev_uri = URI.parse(request.referrer)
      @prev_params = prev_uri.query ? CGI.parse(prev_uri.query) : nil
      @change_search = @search_query && (@search_page != (@prev_params && @prev_params.key?('search_page') ? @prev_params['search_page'][0] : 1))
      @change_custom = @custom_page != (@prev_params && @prev_params.key?('custom_page') ? @prev_params['custom_page'][0] : 1)
      # update window url state
      @url = request.original_fullpath.html_safe

    # on html requests only
    else
      if current_user
        @user_cocktails = current_user.cocktails[0,4] if current_user.cocktails.any?
        @marked_cocktails = current_user.marked[0,4] if current_user.marked.any?
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user_has_reviewed = user_signed_in? && @cocktail.reviewers.include?(current_user)
    if @user_has_reviewed
      @user_review = Review.where(cocktail: @cocktail, user: current_user)[0]
    end
    @review = Review.new
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
    authorize @cocktail
    @dose = Dose.new
    @measurements = Measurement.all
  end

  def update
    authorize @cocktail
    flash = !strong_params.empty? && @cocktail.update(strong_params) ? { notice: 'Update success!' } : { alert: 'Update failed.' }
    redirect_to edit_cocktail_path(@cocktail), flash
  end

  def destroy
    authorize @cocktail
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
        copy
      end

      begin
        Cocktail.transaction do
          @remix.save!
          @doses.each { |d| d.save! }
        end
        # successful saves, redirect to
        redirect_to edit_cocktail_path(@remix), notice: "Successfully remixed! Here in the lab, you can customize your new recipe."
      rescue ActiveRecord::RecordInvalid => invalid
        redirect_to :back, alert: "Failed to remix: #{invalid.record.errors.full_messages.join(' ')}"
      end
    end
  end

  # ajax
  def publish
    authorize @cocktail
    @cocktail.update(published: !@cocktail.published)
    redirect_options = { alert: "Failed to update: #{@errors.full_messages.join(' ')}" } if @cocktail.errors.any?
    respond_to do |format|
      format.html { redirect_to request.referrer, redirect_options || {} }
      format.js
    end
  end

  # ajax
  def mark
    if current_user.marked.include? @cocktail
      # delete mark if exists
      mark = Mark.where(user: current_user, cocktail: @cocktail)[0]
      if !mark.destroy
        @errors = mark.errors
      end
    else
      mark = Mark.new(user: current_user, cocktail: @cocktail)
      if !mark.save
        @errors = mark.errors
      end
    end

    redirect_options = { alert: "Failed to update: #{@errors.full_messages.join(' ')}" } if @errors && @errors.any?

    respond_to do |format|
      format.html { redirect_to request.referrer, redirect_options || {} }
      format.js
    end
  end

  private

  def find_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def strong_params
    params.require(:cocktail).permit(:name, :description, :photo, :instructions, :published)
  end

end
