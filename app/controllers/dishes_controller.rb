class DishesController < ApplicationController
  before_action :find_dish, except: :index

  def index
    @dishes_support = Supports::DishSupport.new dish: Dish.all, param: params
    attach_respond
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

  def attach_respond
    respond_to do |format|
      format.html
      format.json do
        render json: Dish.where_like(params[:name])
      end
    end
  end
end
