Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    passwords: 'users/passwords' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/me', to: 'users#show', as: 'current_user'
  get '/find_friends', to: 'users#index', as: 'strangers'

  resources :users, only: [:show]
  resource :profile, only: [:edit]
  resources :profiles, only: [:update]

  resources :friend_requests, only: %i[index create destroy]
  resources :friends, only: [:index]
  post '/friends/:id', to: 'friends#create', as: 'friend'
  delete '/friends/:id', to: 'friends#destroy'

  resources :posts
  resources :images, only: [:show]
  resources :comments, only: %i[edit update destroy]
  resources :likes, only: [:destroy]
  get '/:reactable_type/:reactable_id/comments', to: 'comments#index', as: 'comments'
  post '/:reactable_type/:reactable_id/comments', to: 'comments#create'
  post '/:reactable_type/:reactable_id/likes', to: 'likes#create', as: 'likes'

  resources :notifications, only: [:index]
  # Defines the root path route ("/")
  # root "articles#index"
  root 'posts#index'
end
