Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  get '/classics', to: 'pages#classics'
  get '/search', to: 'pages#search'

  resources :users, only: [:index, :show]

  resources :cocktails do
    get 'remix', on: :collection
    member do
      post 'remix'
      get 'mark'
      patch 'publish'
    end
    resources :doses, only: [:create, :destroy]
    resources :reviews, except: [:new, :show]
  end

  resources :ingredients, only: [:index]

  match '*path' => 'errors#route_404', via: :all

end
