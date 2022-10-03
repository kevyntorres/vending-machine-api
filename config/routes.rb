Rails.application.routes.draw do
  get '/deposit' => 'index#deposit'
  get '/buy' => 'index#buy'
  get '/reset' => 'index#reset'
  resources :users
  resources :products

  post '/login' => 'authentication#login'
end
