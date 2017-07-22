class OrdersController < ApplicationController
  def index
    input = params[:order]

    return unless input || input[:email]
    check_order Order.find_by code: input[:code]
  end

  def create
    params[:customer_id] = session[:customer]["id"]
    check_already_order
  end

  def show
    dishes_order = current_order.order_dishes
    @order_dishes =
      if dishes_order.blank?
        nil
      else
        dishes_order
      end
    @order_combos = current_order.order_combos
  end

  private

  attr_reader :order, :order_dishes

  def order_params
    params.permit :table_id, :day, :time_in, :customer_id
  end

  def check_already_order
    if current_order.table_id
      session.delete :order_id if current_order.code.present?
      redirect_to cart_path
    else
      @order = current_order
      order.save
      save_order
    end
  end

  def save_order
    session[:order_id] = order.id
    order.update_attributes order_params
    flash[:success] = t "flash.order.create_success"
    UserCreateOrderNotifierMailer.send_email(order).deliver
    render json: {path: cart_path}
  end

  def check_order order
    if order && order.customer.email == params[:email]
      session[:order_id] = order.id
      flash[:success] = t "flash.order.find_order"
      redirect_to cart_path
    else
      flash[:danger] = t "flash.order.cant_find_order"
      redirect_to orders_path
    end
  end
end
