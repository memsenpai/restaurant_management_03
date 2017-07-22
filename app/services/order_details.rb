class OrderDetails
  def initialize param
    @order = param
  end

  def perform
    order_detail
  end

  private

  def order_detail
    @order_dishes = @order.order_dishes
    @order_combos = @order.order_combos
  end
end
