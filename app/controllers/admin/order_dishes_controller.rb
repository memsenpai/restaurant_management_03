module Admin
  class OrderDishesController < ApplicationController
    include AdminLoadOrder
    before_action :authenticate_staff!
    before_action :load_support_dishes
    before_action :find_order_dish
    after_action :change_status, only: :update
    before_action :load_order, only: %i(create update destroy)

    load_and_authorize_resource

    def new
      @order_dish = OrderDish.new
      link = "_order_dish_item"
      respond_to do |format|
        format.html{render link, layout: false, locals: {support: support}}
      end
    end

    def create
      order_dish = OrderDish.first_order_dish(order_dish_params[:dish_id],
        params[:order_id]).first

      if order_dish && (order_dish.no_need? || order_dish.needing?)
        update_already order_dish
      else
        init_order order
      end
    end

    def edit; end

    def update
      dish_params = order_dish_params

      return unless order_dish.update_attributes dish_params
      change_status
      flash[:success] = t "staff_order.success_update"
      redirect_to :back
    end

    def destroy
      return unless order
      delete_order_dish order
    end

    private

    attr_reader :order_dish, :support, :order

    def order_dish_params
      params.require(:order_dish).permit OrderDish::ATTRIBUTES
    end

    def load_order
      @order = support.load_data[:order]
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

    def init_order order
      order.order_dishes.new order_dish_params
      save_order
    end

    def update_already order_dish
      quantity = order_dish.quantity + order_dish_params[:quantity].to_i
      order_dish.update_attributes quantity: quantity
      respond_html "admin/orders/_order_item"
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

    def delete_order_dish order
      if order.order_dishes.delete order_dish
        flash[:success] = t "staff_order.success_delete"
        redirect_to admin_order_path order
      else
        flash[:danger] = t "staff_order.something_wrong"
      end
    end
  end
end
