module Supports
  class AdminOrderDishSupport
    def needing_dishes
      OrderDish.needing.sort_by(&:cooking_time)
    end

    def cooking_dishes
      OrderDish.cooking.sort_by(&:cooking_time)
    end

    def done_dishes
      OrderDish.cooked
    end

    def cancel_dishes
      OrderDish.cancel
    end
  end
end
