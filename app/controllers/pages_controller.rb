class PagesController < ApplicationController

  skip_before_action :authenticate_user!

  def home
    @actions = [
      {
        name: 'Search',
        icon: 'search',
        text: 'Find a diverse variety of cocktails from classics to experimental concoctions.'
      },
      {
        name: 'Create',
        icon: 'lab',
        text: 'Craft your own cocktail recipes to share with the world.'
      },
      {
        name: 'What can I make?',
        icon: 'puzzle piece',
        text: "Tell us what's in your fridge and we'll put together a list of cocktails for you."
      }
    ]
  end

  def search
    query = params[:query].downcase
    by_name = Cocktail.where("lower(name) like ?", '%'+ query +'%')
    by_ingr = Cocktail.joins(:ingredients).where("lower(ingredients.name) like ?", '%'+ query +'%')
    by_desc = Cocktail.where("lower(description) like ?", '%'+ query +'%')
    @results = [
      { result: by_name, keyword: 'name' },
      { result: by_ingr, keyword: 'ingredient' },
      { result: by_desc, keyword: 'description' }
    ]
  end

end
