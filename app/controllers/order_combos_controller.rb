class OrderCombosController < ApplicationController
  include LoadOrder
  before_action :load_order, only: %i(create update destroy)
  before_action :find_combo, only: %i(update destroy)

  def create
    load_order_combo
    if order_combo
      order_combo_update
    else
      order.order_combos.new order_combo_params
      flash[:danger] = t "flash.combo.search_fail" unless order.save
      session[:order_id] = order.id
    end
  end

  def update
    order_combo.update_attributes order_combo_params
    GetOrderDetails.new(order).perform
  end

  def destroy
    order_combo.destroy
    GetOrderDetails.new(order).perform
  end

  private

  attr_reader :order, :order_combo

  def order_combo_params
    params.require(:order_combo).permit :quantity, :combo_id, :status
  end

  def load_order_combo
    @order_combo = order.order_combos.find_by combo_id:
      params[:order_combo][:combo_id]
  end

  def order_combo_update
    order_combo.update_attributes quantity:
      order_combo.quantity + params[:order_combo][:quantity].to_i
  end
end
