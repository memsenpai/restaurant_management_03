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

    def search
      search = Order.ransack param[:q]
      search.sorts = %w(code) if search.sorts.empty?
      search
    end

    def statuses
      Order.statuses.map{|key, _| [key.humanize, key]}
    end
  end
end
