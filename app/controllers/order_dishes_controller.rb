class OrderDishesController < ApplicationController
  def create
    if session[:order_dishes]
      init_order_dish unless update_order_dish
    else
      init_order_dishes
    end
  end

  def update
    change_quantity_order_dish
    update_in_db?
  end

  def destroy
    session[:order_dishes].delete_if do |order_dish|
      params[:id] == order_dish["dish_id"].to_s
    end
    destroy_in_db?
  end

  private

  def init_order_dish
    session[:order_dishes].push order_dish_params
    update_in_db?
  end

  def init_order_dishes
    session[:order_dishes] = [order_dish_params]
    update_in_db?
  end

  def change_quantity order_dish
    order_dishes = session[:order_dishes]
    order_dishes[order_dishes.index(order_dish)]["quantity"] =
      quantity =
        order_dish["quantity"].to_i + order_dish_params[:quantity].to_i
    update_in_db? quantity
  end

  def update_order_dish
    order_dishes = session[:order_dishes]
    order_dish = order_dishes
      .find{|dish| dish["dish_id"] == order_dish_params[:dish_id]}

    return unless order_dish
    change_quantity order_dish
  end

  def change_quantity_order_dish
    session[:order_dishes].map do |order_dish|
      if order_dish_params[:combo_id] == order_dish["combo_id"]
        return order_dish["quantity"] = order_dish_params[:quantity]
      end
    end
  end

  def update_in_db? quantity = nil
    return unless order_save?
    quantity ||= order_dish_params[:quantity]
    dish_id = order_dish_params[:dish_id]
    dish_order =
      OrderDish.find_or_initialize_by order_id: session[:order_id],
        dish_id: dish_id
    dish_order.update_attributes dish_id: dish_id,
      quantity: quantity
  end

  def destroy_in_db
    return unless order_save?
    dish_order = OrderDish.find_by dish_id: params[:order_dish][:id]
    dish_order.destroy if dish_order
  end

  def order_dish_params
    params.require(:order_dish).permit :quantity, :dish_id
  end
end
