class OrdersController < ApplicationController
  def index
    info = params[:order]

    return unless info
    check_order Order.find_by code: info[:code]
  end

  def show
    @order_dishes =
      if current_order.order_dishes.blank?
        nil
      else
        order_dish
      end
    @order_combos = current_order.order_combos
  end

  def create
    params[:guest_id] = session[:guest]["id"]
    check_already_order
  end

  private

  attr_reader :order, :order_dishes

  def order_params
    params.permit :table_id, :day, :time_in, :guest_id
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
    if order && order.guest.email == info[:email]
      session[:order_id] = order.id
      flash[:success] = t "flash.order.find_order"
      redirect_to cart_path
    else
      flash[:danger] = t "flash.order.cant_find_order"
      redirect_to orders_path
    end
  end
end
