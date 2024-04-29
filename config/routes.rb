Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  # devise_scope :user do
  #   unauthenticated do
  #     root to: 'users/sessions#new', as: :unauthenticated_root
  #   end


  root to: 'users/custom_login_register_page#index'

  namespace :admin do
    resources :traders do
      get 'pendings', on: :collection
      post 'approve', on: :member
      get 'balance_new', on: :member
      post 'balance', on: :member
      get 'transactions', on: :collection
    end
  end

  resources :traders do
    member do
      get 'portfolio'
      get 'transaction'
      get 'balance_new'
      post 'balance'
      get 'buy_new'
      post 'buy'
      get 'sell_new'
      post 'sell'
    end
  end

  #this route is only for creating initial admin
  patch 'grant_admin', to: 'admin/traders#grant_admin', as: 'grant_admin'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

end
