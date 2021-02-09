Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :movies, only: [:index, :show]

  resources :users, only: [:new, :create]
  
  resources :friendships, only: [:create]

  resources :parties, only: [:new, :create]

  get '/dashboard', to: 'dashboard#index'
  get '/discover', to: 'discover#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'
end
