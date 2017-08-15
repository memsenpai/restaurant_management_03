module Admin
  class OrderCombosController < ApplicationController
    include AdminLoadOrder
    before_action :authenticate_staff!
    before_action :load_support_combos
    before_action :find_order_combo
    before_action :load_order, only: %i(create update destroy)

    load_and_authorize_resource

    def new
      @order_combo = OrderCombo.new
      link = "_order_combo_item"
      respond_to do |format|
        format.html{render link, layout: false, locals: {support: support}}
      end
    end

    def create
      combo = OrderCombo.first_order_combo(order_combo_params[:combo_id],
        params[:order_id]).first

      if combo && (combo.no_need? || combo.needing?)
        update_already combo
      else
        init_order order
      end
    end

    def edit; end

    def update
      combo_params = order_combo_params

      return unless order_combo.update_attributes combo_params
      change_status
      flash[:success] = t "staff_order.success_update"
      redirect_to :back
    end

    def destroy
      if order
        if order.order_combos.delete order_combo
          flash[:success] = t "staff_order.success_delete"
        else
          flash[:danger] = t "staff_order.something_wrong"
        end
      end
      redirect_to :back
    end

    private

    attr_reader :order_combo, :support, :order

    def order_combo_params
      params.require(:order_combo).permit :combo_id, :quantity, :status
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
      order.order_combos.new order_combo_params
      save_order
    end

    def update_already order_combo
      quantity = order_combo.quantity + order_combo_params[:quantity].to_i
      order_combo.update_attributes quantity: quantity
      respond_html "admin/orders/_order_item"
    end
  end
end
