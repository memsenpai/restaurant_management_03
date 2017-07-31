module Supports
  class CustomerSupport
    attr_reader :customers, :param

    def initialize arg
      @customers = arg[:customers]
      @param = arg[:param]
    end

    def customers_search
      search.result.page(param[:page]).per_page Settings.limit
    end

    def search
      search = Customer.ransack param[:q]
      search.sorts = "id desc" if search.sorts.empty?
      search
    end
  end
end
