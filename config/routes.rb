Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  root 'home#about'


  devise_for :users, :controllers => {
    :registrations => 'user/registrations',
    :sessions => 'user/sessions'
  }

  devise_scope :user do
    get "user/:id", :to => "user/registrations#detail"
    get "signup", :to => "user/registrations#new"
    get "login", :to => "user/sessions#new"
    get "logout", :to => "user/sessions#destroy"
  end

  get "dashbord" => "dashbord#index"
  namespace :api do
    resources :users, only: [:index, :show]
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/auth/registrations'
    }
  end
end
