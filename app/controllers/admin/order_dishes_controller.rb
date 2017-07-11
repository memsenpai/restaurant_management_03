class Admin::OrderDishesController < ApplicationController
  include AdminLoadOrder
  before_action :logged_in_admin
  before_action :load_support_dishes
  before_action :find_order_dish

  load_and_authorize_resource

  def new
    @order_dish = OrderDish.new
    link = "_order_dish_item"
    respond_to do |f|
      f.html{render link, layout: false, locals: {support: @support}}
    end
  end

  def create
    order = @support.load_data[:order]
    @order_dish = order.order_dishes.new order_dish_params
    if order.save!
      flash[:success] = t "admin_order.success_add"
      l = "admin/orders/_order_item"
      respond_to do |f|
        f.html{render l, layout: false, locals: {order: order}}
      end
    else
      flash[:danger] = t "admin_order.something_wrong"
      redirect_to :back
    end
  end

  def edit
  end

  def update
    params_update = order_dish_params
    if @order_dish.update_attributes params_update
      flash[:success] = t "admin_order.success_update"
    else
      flash[:danger] = t "admin_order.something_wrong"
    end
    redirect_to :back
  end

  def destroy
    order = @support.load_data[:order]
    if order
      order_dish = order.order_dishes
      if order_dish.delete @order_dish
        flash[:success] = t "admin_order.success_delete"
        redirect_to admin_order_path order
      else
        flash[:danger] = t "admin_order.something_wrong"
      end
    end
  end

  private
  def order_dish_params
    params.require(:order_dish).permit :dish_id, :order_id, :quantity, :status
  end
end
