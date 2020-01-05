Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  root 'home#about'

  namespace :api do
    resources :users, only: [:index, :show]
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/auth/registrations'
    }

  end
end
