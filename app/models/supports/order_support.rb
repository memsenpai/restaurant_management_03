module Supports
  class OrderSupport
    attr_reader :orders, :param

    def initialize arg
      @orders = arg[:order]
      @param = arg[:param]
    end

    def orders_search
      search.result.page(param[:page]).per_page Settings.max_result
    end

    def tables
      Table.all
    end

    def search
      search =
        if param[:type]
          orders.ransack
        else
          Order.ransack param[:q]
        end
      search
    end

    def statuses
      Order.statuses.map{|key, _| [key.humanize, key]}
    end
  end
end
