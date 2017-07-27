module Supports
  class DishSupport
    attr_reader :dishes, :param

    def initialize arg
      @dishes = arg[:dish]
      @param = arg[:param]
    end

    def dishes_search
      search.result.page(param[:page]).per_page Settings.limit
    end

    def search
      search = Dish.ransack param[:q]
      search.sorts = %w(name price) if search.sorts.empty?
      search
    end

    def dishes_data
      OrderDish
        .select("dish_id, sum(quantity) as total_quantity")
        .group(:dish_id).order("total_quantity DESC").limit Settings.limit
    end
  end
end
