Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/me', to: 'users#show', as: 'current_user'
  resources :users, only: %i[index show]
  resource :profile, only: [:edit]
  resources :profiles, only: [:update]

  resources :posts, except: [:show]
  # Defines the root path route ("/")
  # root "articles#index"
  root 'posts#index'
end
