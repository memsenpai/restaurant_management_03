Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  root "pages#show", page: "home"
  get "/pages/:page" => "pages#show"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resource :admin, only: [:show, :edit, :update]
  resources :dishes
  resources :orders, only: [:show, :index, :create]
  get "/cart", to: "orders#show"
  resources :order_dishes, only: [:create, :update, :destroy]
  resources :tables
  resources :guests
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
      resources :order_dishes
      resources :order_combos
    end
    resources :discount_codes
    resources :users
    resources :chef
  end
end
