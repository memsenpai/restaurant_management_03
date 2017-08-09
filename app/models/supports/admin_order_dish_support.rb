module Supports
  class AdminOrderDishSupport
    def dishes status
      order_dishes = OrderDish.send(status).sort_by(&:cooking_time)
      merge_duplication order_dishes
    end

    private

    def delete_duplication dish, order_dishes
      order_dishes.map do |dish_delete|
        id = dish_delete.id
        if dish.dish_id == dish_delete.dish_id && dish.id != id
          dish.quantity += dish_delete.quantity
          order_dishes.delete_if{|item| item.id == id}
        end
      end
    end

    def merge_duplication order_dishes
      order_dishes.map do |dish|
        delete_duplication dish, order_dishes
      end
      order_dishes
    end
  end
end
