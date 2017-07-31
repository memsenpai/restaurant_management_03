class DishesController < ApplicationController
  before_action :find_dish, except: :index

  def index
    @dishes_support = Supports::DishSupport.new dish: Dish.all, param: params
  end

  def show
    @order_dish = current_order.order_dishes.new
  end

  private

  attr_reader :dish

  def find_dish
    @dish = Dish.find_by id: params[:id]

    return session[:dish_id] = dish.id if dish
    redirect_to dishes_path
    flash[:danger] = t "flash.dish.find_fail"
  end
end
