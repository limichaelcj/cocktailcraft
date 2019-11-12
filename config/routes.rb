Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  resources :cocktails do
    collection do
      get 'remix'
    end
    member do
      post 'remix'
    end
    resources :doses, only: [:create, :update, :destroy]
  end

end
