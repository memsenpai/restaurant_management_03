module Admin
  class OrderDishesController < ApplicationController
    include AdminLoadOrder
    before_action :authenticate_staff!
    before_action :load_support_dishes
    before_action :find_order_dish
    after_action :change_status, only: :update

    load_and_authorize_resource

    def new
      @order_dish = OrderDish.new
      link = "_order_dish_item"
      respond_to do |format|
        format.html{render link, layout: false, locals: {support: support}}
      end
    end

    def create
      @order = support.load_data[:order]
      params_create = order_dish_params
      order_dish = OrderDish.find_by dish_id: params_create[:dish_id],
        order_id: params[:order_id]
      if order_dish
        quantity = order_dish.quantity + params_create[:quantity].to_i
        order_dish.update_attributes quantity: quantity
        respond_html "admin/orders/_order_item"
      else
        order.order_dishes.new params_create
        save_order
      end
    end

    def edit; end

    def update
      order = support.load_data[:order]
      dish_params = order_dish_params
      return unless order_dish.update_attributes dish_params
      change_status
      flash[:success] = t "staff_order.success_update"
      redirect_to :back
      HistoryOrder.create order_id: order.id, brand: "add_dish",
        time: order.updated_at, item_id: order_dish.id,
        describe: dish_params[:quantity]
    end

    def destroy
      order = support.load_data[:order]
      order_dish.cancel!
      redirect_to :back
      HistoryOrder.create order_id: order.id, brand: "cancel_dish",
        time: Time.now.in_time_zone, item_id: order_dish.id,
        describe: order_dish_params[:quantity]
    end

    private

    attr_reader :order_dish, :support, :order

    def order_dish_params
      params.require(:order_dish).permit :dish_id,
        :order_id, :quantity, :status
    end

    def respond_html layout
      respond_to do |format|
        format.html{render layout, layout: false, locals: {order: order}}
      end
    end

    def save_order
      if order.save!
        flash[:success] = t "staff_order.success_add"
        respond_html "admin/orders/_order_item"
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to :back
      end
    end

    def check_status_items_in_order? order
      order.order_dishes.map do |item|
        next if item.served? || item.cancel?
        break false
      end
    end

    def change_status
      order = Order.find_by id: order_dish.order_id
      return unless check_status_items_in_order? order
      order.done!
    end

    def respond_to_html
      link = "_order_dish_item"
      respond_to do |format|
        format.html{render link, layout: false, locals: {support: support}}
      end
    end
  end
end
