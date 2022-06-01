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
    member do
      patch 'deactivate'
      patch 'activate'
    end
  end
  resources :shipping_prices, only: %i[index new create]
  resources :min_shipping_prices, only: %i[new create]
  resources :shipping_deadlines, only: %i[index new create]
  resources :items, only: %i[new create]
  resources :quotes, only: %i[index] do
    get 'generated', on: :collection
  end
  resources :service_orders, only: %i[new create show index] do
    member do
      get 'set_vehicle'
      patch 'accept'
      patch 'reject'
    end
    resources :route_updates, only: %i[index create]
    get 'tracking', on: :collection
  end
  resources :vehicles, only: %i[index new create]
end
