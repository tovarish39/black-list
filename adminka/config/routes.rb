Rails.application.routes.draw do
  get 'moderators/index'
  root 'users#index'
  
  resources :users
  resources :scamers
  resources :moderators
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
