class OrderDishesController < ApplicationController
  include LoadOrder
  before_action :load_order, only: %i(create update destroy)
  before_action :find_dish, only: %i(update destroy)

  def create
    order_dishes
    if order_dish
      update_order
    else
      @order_dish = order.order_dishes.new order_dish_params
      order.save
      session[:order_id] = order.id
    end
  end

  def update
    order_dish.update_attributes order_dish_params
    OrderDetails.new(order).perform
  end

  def destroy
    order_dish.destroy
    OrderDetails.new(order).perform
  end

  private

  attr_reader :order_dish, :order

  def order_dishes
    @order_dish = order.order_dishes.find_by dish_id:
      params[:order_dish][:dish_id]
  end

  def order_dish_params
    params.require(:order_dish).permit :quantity, :dish_id
  end

  def update_order
    order_dish.update_attributes quantity:
      order_dish.quantity + params[:order_dish][:quantity].to_i
  end
end
