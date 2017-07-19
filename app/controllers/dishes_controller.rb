class DishesController < ApplicationController
  before_action :find_dish, except: :index

  def index
    @dishes_support = Supports::Dish.new dish: Dish.all, param: params
  end

  def show
    @order_dish = current_order.order_dishes.new
  end

  private

  attr_reader :dish

  def find_dish
    @dish = Dish.find_by id: params[:id]
    flash[:danger] = t "flash.dish.find_fail" unless dish
  end
end
