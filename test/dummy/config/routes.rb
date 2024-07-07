# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users do
    resources :hats
  end
  get 'home/index'
  root to: 'home#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  mount LoggableActivity::Engine => '/loggable_activity'
end
