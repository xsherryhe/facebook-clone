Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/me', to: 'users#show', as: 'current_user'
  get '/friends', to: 'users#index', defaults: { is_friend: true }, as: 'friends'
  get '/find_friends', to: 'users#index', defaults: { is_friend: false }, as: 'strangers'

  resources :users, only: [:show]
  resource :profile, only: [:edit]
  resources :profiles, only: [:update]

  resources :friend_requests, only: %i[index create destroy]
  post '/friends/:id', to: 'friends#create', as: 'create_friend'

  resources :posts, except: [:show]
  # Defines the root path route ("/")
  # root "articles#index"
  root 'posts#index'
end
