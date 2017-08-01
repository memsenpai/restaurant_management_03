module Supports
  class PromoSupport
    attr_reader :promos, :param

    def initialize arg
      @promos = arg[:promos]
      @param = arg [:param]
    end

    def dishes
      promos.map(&:dish)
    end

    def promos_search
      search.result.page(param[:page]).per_page Settings.limit
    end

    def search
      search = dish_search.ransack
      search.sorts = %w(created_at desc name) if search.sorts.empty?
      search
    end

    private

    def dish_search
      q = param[:q]
      return Promo.all unless q
      return Promo.all if q[:dish_id_eq] == ""
      Promo.joins(:dish).where("name like ?", "%" + q[:dish_id_eq] + "%")
    end

  end
end
