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
    post "analyze/text_detect", to: 'api/analyze#text_detect'
    resources :users, only: [:index, :show] do
      resources :bills do
        member do
          post :send_mail
          get :sent_mails
        end
      end
      resources :friends
    end
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/auth/registrations'
    }
  end

  # link in mail
  get "action/:token", to: 'mail_response#new'
  post "action/:token", to: 'mail_response#create'
  get "done", to: 'mail_response#done'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
