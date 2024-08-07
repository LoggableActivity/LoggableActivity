# frozen_string_literal: true

LoggableActivity::Engine.routes.draw do
  resources :activities, only: %i[index show] 

  root to: 'activities#index'
end
