require "api_constraints"

namespace :api, defaults: {format: "json"} do
  devise_scope :staff do
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"
  end
  resources :tables, only: %i(index show) do
    resources :orders, only: %i(index show) do
      resources :order_dishes
      resources :order_combos
    end
  end
  resources :orders, only: %i(index show) do
    resources :order_dishes
    resources :order_combos
  end
  resources :dishes, only: %i(index show)
  resources :combos, only: %i(index show)
  get "/charts/income", to: "income_charts#index"
  get "/charts/dish_orders", to: "order_dish_charts#index"
  get "/charts/combo_orders", to: "order_combo_charts#index"
  get "/charts/timein", to: "timein_charts#index"
end
