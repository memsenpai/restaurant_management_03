module Admin
  class OrderCombosController < ApplicationController
    include AdminLoadOrder
    before_action :authenticate_staff!
    before_action :load_support_combos
    before_action :find_order_combo
    after_action :change_status, only: :update

    load_and_authorize_resource

    def new
      @order_combo = OrderCombo.new
      respond_html
      link = "_order_combo_item"
      respond_to do |format|
        format.html{render link, layout: false, locals: {support: support}}
      end
    end

    def create
      @order = support.load_data[:order]
      params_create = order_combo_params
      order_combo = OrderCombo.find_by combo_id: params_create[:combo_id],
        order_id: params[:order_id]
      if order_combo
        quantity = order_combo.quantity + params_create[:quantity].to_i
        order_combo.update_attributes quantity: quantity
        respond_html "admin/orders/_order_item"
      else
        order.order_combos.new params_create
        save_order
      end
    end

    def edit; end

    def update
      @order = support.load_data[:order]
      combo_params = order_combo_params
      return unless order_combo.update_attributes combo_params
      change_status
      flash[:success] = t "staff_order.success_update"
      respond_html "admin/orders/_order_item"
      HistoryOrder.create order_id: order.id, brand: "add_combo",
        time: order.updated_at, item_id: order_combo.id,
        describe: combo_params[:quantity]
    end

    def destroy
      @order = support.load_data[:order]
      order_combo.cancel!
      respond_html "admin/orders/_order_item"
      HistoryOrder.create order_id: order.id, brand: "cancel_combo",
        time: Time.now.in_time_zone, item_id: order_combo.id,
        describe: order_combo_params[:quantity]
    end

    private

    attr_reader :order_combo, :support, :order

    def order_combo_params
      params.require(:order_combo).permit :combo_id, :quantity, :status
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
      order.order_combos.map do |item|
        next if item.served? || item.cancel?
        break false
      end
    end

    def change_status
      order = Order.find_by id: order_combo.order_id
      return unless check_status_items_in_order? order
      order.done!
    end
  end
end
