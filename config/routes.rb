Rails.application.routes.draw do
  devise_for :staffs, skip: :sessions, controller: {sessions: "sessions"}
  devise_scope :staff do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
  mount ActionCable.server => "/cable"
  root "pages#show", page: "home"
  get "/pages/:page" => "pages#show"
  resource :staffs, only: %i(show edit update)
  resources :dishes
  resources :orders, only: %i(show index create)
  get "/cart", to: "orders#show"
  resources :order_dishes, only: %i(create update destroy)
  resources :tables, only: %i(index)
  resources :customers, only: %i(new create index)
  resources :order_combos, only: %i(create update destroy)
  resources :combos, only: %i(index show)
  namespace :admin do
    resources :categories do
      resources :dishes
      resources :category_dishes, only: %i(destroy)
    end
    resources :dishes
    resources :combos do
      resources :dishes
      resources :combo_dishes, only: %i(destroy)
    end
    resources :orders do
      resources :order_dishes, except: %i(show index)
      resources :order_combos, except: %i(show index)
    end
    resources :discount_codes
    resources :users, except: %i(show)
    resources :promos
    resources :chef
    resources :bills
    resources :bill_details
    resources :xml
  end

end
