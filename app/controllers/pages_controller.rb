class PagesController < ApplicationController

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
    render 'pages/home'
  end

end
