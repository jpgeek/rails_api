# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :sessions, only: [:create] do
        delete :logout, to: 'sessions#logout', on: :collection 
      end
    end
  end
end
