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
  get "/charts/staffs", to: "staff_charts#index"
  get "/charts/orders", to: "order_charts#index"
end
