module LoadOrder
  def load_order
    @order = current_order
  end

  def find_combo
    @order_combo = order.order_combos.find_by id: params[:id]

    return if order_combo
    flash[:danger] = t "flash.dish.find_fail"
  end

  def find_dish
    @order_dish = order.order_dishes.find_by id: params[:id]

    return if order_dish
    flash[:danger] = t "flash.dish.find_fail"
  end
end
