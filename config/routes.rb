Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root to: 'home#index'
  namespace :user do
    root to: 'home#index'
  end
  namespace :admin do
    root to: 'home#index'
  end
  resources :shipping_companies, only: %i[index new create show] do
    patch 'deactivate', on: :member
    patch 'activate', on: :member
  end
  resources :shipping_prices, only: %i[index new create]
  resources :min_shipping_prices, only: %i[new create]
  resources :shipping_deadlines, only: %i[index new create]
  resources :items, only: %i[new create]
  resources :quotes, only: %i[index] do
    get 'generated', on: :collection
  end
  resources :service_orders, only: %i[new create show index] do
    get 'set_vehicle', on: :member
    patch 'accept', on: :member
    patch 'reject', on: :member
  end
  resources :vehicles, only: %i[index new create]
end
