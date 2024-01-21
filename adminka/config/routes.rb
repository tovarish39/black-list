Rails.application.routes.draw do
  root 'users#index'

  resources :users
  post '/users/send_message', to: 'users#send_message'
  resources :scamers
  resources :moderators
  post '/moderators/send_message', to: 'moderators#send_message'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
