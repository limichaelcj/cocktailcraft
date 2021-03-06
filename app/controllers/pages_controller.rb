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
        text: "Tell us what's in your fridge and we'll put together a list of cocktails for you.",
        wip: true,
      }
    ]
    @top_rated = Cocktail.all.sort_by do |c|
      -c.rating
    end[0, 8]
    @popular = Cocktail.all.sort_by do |c|
      -(c.marks.count + c.reviews.count)
    end[0, 8]
  end

  def search
    @query = params[:query].downcase
    @results = Cocktail.search_keyword(@query)
  end

  private

  def sort_search_results(arr)
    arr.each_with_object(Hash.new(0)) do |tuple, h|
      h[tuple[:id]] += tuple[:weight]
    end.sort_by { |k,v| -v }.map { |tuple| Cocktail.find(tuple[0]) }
  end

end
