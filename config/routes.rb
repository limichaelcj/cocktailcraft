Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  get '/search', to: 'pages#search'

  resources :users, only: [:index, :show]

  resources :cocktails do
    collection do
      get 'remix'
    end
    member do
      post 'remix'
      get 'mark'
    end
    resources :doses, only: [:create, :update, :destroy]
    resources :reviews, except: [:new, :show]
  end

  resources :ingredients, only: [:index]

end
