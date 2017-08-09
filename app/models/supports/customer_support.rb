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
      search =
        if param[:type]
          customers.ransack
        else
          customers.ransack param[:q]
        end
      search
    end
  end
end
