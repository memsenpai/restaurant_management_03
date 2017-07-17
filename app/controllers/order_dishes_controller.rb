class OrderDishesController < ApplicationController
  include LoadOrder
  before_action :load_order, only: %i(create update destroy)
  before_action :find_dish, only: %i(update destroy)

  def create
    @order_dish = @order.order_dishes.new order_dish_params
    @order.save
    session[:order_id] = @order.id
  end

  def update
    @order_dish.update_attributes order_dish_params
    GetOrderDetails.new(@order).perform
  end

  def destroy
    @order_dish.destroy
    GetOrderDetails.new(@order).perform
  end

  private
  def order_dish_params
    params.require(:order_dish).permit :quantity, :dish_id
  end
end
