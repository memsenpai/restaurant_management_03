module Supports
  class DashboardStatisticSupport
    def dishes_count
      Dish.count
    end

    def combos_count
      Combo.count
    end

    def staffs_count
      Staff.count
    end

    def categories_count
      Category.count
    end
  end
end
