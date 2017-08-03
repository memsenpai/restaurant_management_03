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

    attr_reader :info, :all_item

    def init_var
      @info = param[:q]
      @all_item = Promo.all
    end

    def dish_search
      init_var

      return all_item unless info
      name_dish = info[:dish_id_eq]

      return all_item if name_dish == ""
      Promo.joins(:dish).where("name like ?", "%" + name_dish + "%")
    end
  end
end
