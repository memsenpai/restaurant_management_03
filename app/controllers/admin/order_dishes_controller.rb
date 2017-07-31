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
      order.order_dishes.new order_dish_params
      save_order
    end

    def edit; end

    def update
      params_update = order_dish_params
      if order_dish.update_attributes params_update
        flash[:success] = t "staff_order.success_update"
        redirect_to :back
      else
        redirect_to edit_admin_order_order_dish_path
      end
    end

    def destroy
      order = support.load_data[:order]

      return unless order
      delete_order_dish
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

    def delete_order_dish
      if order.order_dishes.delete order_dish
        flash[:success] = t "staff_order.success_delete"
        redirect_to admin_order_path order
      else
        flash[:danger] = t "staff_order.something_wrong"
      end
    end
  end
end
