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

  resources :friend_requests, only: %i[index create]
  resources :friends, only: %i[index destroy] do
    resources :friend_requests, only: [:destroy]
  end
  post '/friends/:id', to: 'friends#create'

  resources :posts
  resources :images, only: [:show]
  get '/:reactable_type/:reactable_id/comments', to: 'comments#index', as: 'comments'
  post '/:reactable_type/:reactable_id/comments', to: 'comments#create'
  get '/:reactable_type/:reactable_id/comments/:id/edit', to: 'comments#edit', as: 'edit_comment'
  patch '/:reactable_type/:reactable_id/comments/:id', to: 'comments#update', as: 'comment'
  put '/:reactable_type/:reactable_id/comments/:id', to: 'comments#update'
  delete '/:reactable_type/:reactable_id/comments/:id', to: 'comments#destroy'
  post '/:reactable_type/:reactable_id/likes', to: 'likes#create', as: 'likes'
  delete '/:reactable_type/:reactable_id/likes/:id', to: 'likes#destroy', as: 'like'

  resources :notifications, only: [:index]
  # Defines the root path route ("/")
  # root "articles#index"
  root 'posts#index'
end
