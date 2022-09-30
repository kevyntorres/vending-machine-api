Rails.application.routes.draw do
  get 'index/deposit'
  get 'index/buy'
  get 'index/reset'
  resources :users
  resources :products
end
