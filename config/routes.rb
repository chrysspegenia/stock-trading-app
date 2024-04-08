Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'custom_sessions'}

  authenticated :user do
    root to: 'custom_sessions#after_sign_in_path_for', as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :traders 

  namespace :admin do
    resources :traders
  end

  #this route is only for creating initial admin
  patch 'grant_admin', to: 'admin/traders#grant_admin', as: 'grant_admin'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  
end
