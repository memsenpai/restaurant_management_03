class OrdersController < ApplicationController
  def index
    input = params[:order]

    return unless input
    check_order Order.find_by(code: input[:code]), input
  end

  def create
    session_customer = session[:customer]
    return unless session_customer
    params[:customer_id] = session_customer["id"]
    renew_order
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

  def order_save_success
    session[:order_id] = order.id
    flash[:success] = t "flash.order.create_success"
    UserCreateOrderNotifierMailer.send_email(order).deliver
    render json: {path: cart_path}
  end

  def order_params
    params.permit :table_id, :day, :time_in, :customer_id
  end

  def renew_order
    session.delete :order_id if current_order.code.present?
    @order = Order.new order_params
    save_order
  end

  def save_order
    if order.save
      order_save_success
    else
      flash[:danger] = t "flash.order.create_fail"
      render "tables/index"
    end
  end

  def check_order order, input
    if order && order.customer.email == input[:email]
      session[:order_id] = order.id
      flash[:success] = t "flash.order.find_order"
      redirect_to cart_path
    else
      flash[:danger] = t "flash.order.cant_find_order"
      redirect_to orders_path
    end
  end
end
