class ActionDispatch::Routing::Mapper
  def draw routes_name
    instance_eval File.read(Rails.root.join("config/routes/#{routes_name}.rb"))
  end
end

Rails.application.routes.draw do
  post "/rate", to: "rater#create", as: "rate"
  devise_for :staffs, skip: :sessions, controller: {sessions: "sessions"}
  draw :api
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
  resources :orders, except: %i(edit update destroy)
  get "/cart", to: "orders#show"
  resources :order_dishes, only: %i(create update destroy)
  resources :tables, only: %i(index new)
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
    resources :update_items
    resources :discount_codes
    resources :staffs, except: %i(show)
    resources :promos
    resources :chef
    resources :bills
    resources :dashboards, only: %i(index)
    resources :bill_details, except: %i(new edit show)
    resources :xml, only: %i(show)
    resources :membership_coupons, except: %i(new edit show)
    resources :customers, except: %i(new edit show)
  end
end
