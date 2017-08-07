class OrderServices
  def initialize param
    @order = param
    @order_combos = order.order_combos
    @order_dishes = order.order_dishes
  end

  def perform
    order_detail
  end

  def subtotal
    subtotal_combos_map.sum + subtotal_dishes_map.sum
  end

  def original_price
    original_combos_map.sum + original_dishes_map.sum
  end

  def total_item
    order_combos.map(&:quantity).sum +
      order_dishes.map(&:quantity).sum
  end

  def change_status
    case order.status
    when "uncheck", "declined"
      "approved"
    when "approved"
      "serving"
    when "serving"
      "done"
    end
  end

  def price_final
    (subtotal * (100 - order.discount -
      order.customer.membership_discount)) / 100
  end

  private

  attr_reader :order, :order_combos, :order_dishes

  def original_combos_map
    order_combos.map do |order_combo|
      next 0 if order_combo.cancel?
      order_combo.valid? ? order_combo.quantity * order_combo.original_price : 0
    end
  end

  def original_dishes_map
    order_dishes.map do |order_dish|
      next 0 if order_dish.cancel?
      order_dish.valid? ? order_dish.quantity * order_dish.price : 0
    end
  end

  def subtotal_combos_map
    order_combos.map do |order_combo|
      next 0 if order_combo.cancel?
      order_combo.valid? ? order_combo.total_price : 0
    end
  end

  def subtotal_dishes_map
    order_dishes.map do |order_dish|
      next 0 if order_dish.cancel?
      order_dish.valid? ? order_dish.total_price : 0
    end
  end

  def order_detail
    @order_dishes = @order.order_dishes
    @order_combos = @order.order_combos
  end
end
