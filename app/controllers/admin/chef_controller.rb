module Admin
  class ChefController < ApplicationController
    before_action :authenticate_staff!

    load_and_authorize_resource class: :chef

    def index
      @order_dishes = Supports::AdminOrderDishSupport.new
      @order_combos = Supports::AdminOrderComboSupport.new
    end
  end
end
