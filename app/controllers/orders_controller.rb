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
    save_order
  end

  def new
    session.clear
    redirect_to :back
  end

  def show
    @order_dishes = current_order.order_dishes
    @order_combos = current_order.order_combos
  end

  private

  attr_reader :order, :order_dishes

  def create_items items
    items_in_session = session[items.to_sym]

    return unless items_in_session
    items_in_session.map do |item|
      order.send(items).new item
    end
  end

  def create_order_item
    session[:customer_id] = order.customer_id
    create_items "order_combos"
    create_items "order_dishes"
  end

  def order_save_success
    HistoryOrder.create order_id: current_order.id, brand: "create_order",
      time: current_order.created_at, describe: "Create"
    NotifierMailer.create_order(current_order).deliver
    render json: {path: cart_path}
  end

  def order_params
    params.permit :table_id, :day, :time_in, :customer_id
  end

  def already_order_id
    order_id = session[:order_id]

    return Order.update order_id, order_params if order_id
    @order = Order.new order_params
    create_order_item
    order.save
  end

  def save_order
    if already_order_id
      session[:order_id] ||= order.id
      order_save_success
    else
      flash[:danger] = t "flash.order.create_fail"
      render "tables/index"
    end
  end

  def fill_order_to_session
    order_id = session[:order_id]
    session[:order_dishes] = OrderDish.load_order_dishes order_id
    session[:order_combos] = OrderCombo.load_order_combos order_id
  end

  def check_order_success order
    session[:order_id] = order.id
    session[:customer_id] = order.customer_id
    fill_order_to_session
    flash[:success] = t "flash.order.find_order"
    redirect_to cart_path
  end

  def check_order order, input
    if order && order.customer.email == input[:email]
      check_order_success order
    else
      flash[:danger] = t "flash.order.cant_find_order"
      redirect_to orders_path
    end
  end
end
