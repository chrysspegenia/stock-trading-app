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


  root to: 'users/custom_login_register_page#index', as: :root

  resources :traders
  namespace :admin do
    resources :traders do
      get 'pendings', on: :collection
      post 'approve', on: :member
      post 'initialize_balance', on: :collection
      get 'transaction', on: :collection
    end
  end

  get 'buy_new', to: 'traders#buy_new', as: 'buy_new_trader'
  post 'buy', to: 'traders#buy', as: 'buy_trader'
  get 'sell', to: 'traders#sell_new', as: 'sell_new_trader'
  post 'sell', to: 'traders#sell', as: 'sell_trader'
  get 'portfolio', to: 'traders#portfolio', as: 'portfolio_trader'
  get 'transaction', to: 'traders#transaction', as: 'transaction_trader'
  get 'init_balance_new', to: 'traders#init_balance_new', as: 'init_balance_new'
  post 'init_balance', to: 'traders#init_balance', as: 'init_balance'

  #this route is only for creating initial admin
  patch 'grant_admin', to: 'admin/traders#grant_admin', as: 'grant_admin'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

end
