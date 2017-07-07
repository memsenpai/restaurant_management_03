class OrderCombosController < ApplicationController
  include LoadOrder
  before_action :load_order, only: [:create, :update, :destroy]
  before_action :find_combo, only: [:update, :destroy]

  def create
    @order_combo = @order.order_combos.new order_combo_params
    flash[:danger] = t "flash.combo.search_fail" unless @order.save
    session[:order_id] = @order.id
  end

  def update
    @order_combo.update_attributes order_combo_params
    GetOrderDetails.new(@order).perform
  end

  def destroy
    @order_combo.destroy
    GetOrderDetails.new(@order).perform
  end

  private
  def order_combo_params
    params.require(:order_combo).permit :quantity, :combo_id, :status
  end
end
