# frozen_string_literal: true

Rails.application.routes.draw do
  mount LoggableActivity::Engine => '/loggable_activity'
end
