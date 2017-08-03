class OrderCombosController < ApplicationController
  def create
    return unless current_order.uncheck?
    if session[:order_combos]
      init_order_combo unless update_order_combo
    else
      init_order_combos
    end
  end

  def update
    change_quantity_order_combo
    update_in_db?
  end

  def destroy
    session[:order_combos].delete_if do |order_combo|
      params[:id] == order_combo["combo_id"].to_s
    end
    destroy_in_db
  end

  private

  def init_order_combo
    session[:order_combos].push order_combo_params
    update_in_db?
  end

  def init_order_combos
    session[:order_combos] = [order_combo_params]
    update_in_db?
  end

  def change_quantity order_combo
    order_combos = session[:order_combos]
    order_combos[order_combos.index(order_combo)]["quantity"] =
      quantity =
        order_combo["quantity"].to_i + order_combo_params[:quantity].to_i
    update_in_db? quantity
    true
  end

  def update_order_combo
    order_combos = session[:order_combos]
    order_combo = order_combos
      .find{|combo| combo["combo_id"] == order_combo_params[:combo_id]}

    return unless order_combo
    change_quantity order_combo
  end

  def change_quantity_order_combo
    session[:order_combos].map do |order_combo|
      if order_combo_params[:combo_id] == order_combo["combo_id"]
        return order_combo["quantity"] = order_combo_params[:quantity]
      end
    end
  end

  def update_in_db? quantity = nil
    return unless order_save?
    quantity ||= order_combo_params[:quantity]
    combo_id = order_combo_params[:combo_id]
    combo_order =
      OrderCombo.find_or_initialize_by order_id: session[:order_id],
        combo_id: combo_id
    combo_order.update_attributes combo_id: combo_id, quantity: quantity
  end

  def destroy_in_db
    return unless order_save?
    combo_order = OrderCombo.find_by combo_id: params[:order_combo][:id]
    combo_order.destroy if combo_order
  end

  def order_combo_params
    params.require(:order_combo).permit :quantity, :combo_id, :status
  end
end
