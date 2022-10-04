# frozen_string_literal: true

Rails.application.routes.draw do
  post '/deposit' => 'users#deposit'
  post '/buy' => 'products#buy'
  post '/reset' => 'users#reset_deposit'
  resources :users
  resources :products

  post '/login' => 'authentication#login'
end
