Rails.application.routes.draw do
  root :to => 'dashboard#show'
  resources :user_sessions
  resources :users

  get 'dashboard', to: 'dashboard#show'
  
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
end
