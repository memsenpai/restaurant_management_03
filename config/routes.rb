Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  root "pages#show", page: "home"
  get "/pages/:page" => "pages#show"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resource :administrator, only: [:show, :edit, :update]
  resources :dishes
  resources :orders, only: [:show, :index, :create]
  get "/cart", to: "orders#show"
  resources :order_dishes, only: [:create, :update, :destroy]
  resources :tables, only: [:index]
  resources :guests, only: [:new, :create, :index]
  resources :order_combos, only: [:create, :update, :destroy]
  resources :combos, only: [:index, :show]
  namespace :admin do
    resources :categories do
      resources :dishes
    end
    resources :dishes
    resources :combos do
      resources :dishes
    end
    resources :orders do
      resources :order_dishes, except: [:show, :index]
      resources :order_combos, except: [:show, :index]
    end
    resources :discount_codes
    resources :users, except: [:show]
    resources :promos
    resources :chef
    resources :bills
    resources :bill_details
    resources :xml
  end
end
