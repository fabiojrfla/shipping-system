Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root to: 'home#index'
  namespace :panel do
    root to: 'home#index'
  end
  namespace :admin do
    root to: 'home#index'
  end
  resources :shipping_companies, only: %i[index new create]
end
