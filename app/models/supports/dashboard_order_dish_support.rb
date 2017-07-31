module Supports
  class DashboardOrderDishSupport
    attr_reader :param, :datefrom, :dateto, :dish

    def initialize arg
      @param = arg[:param]
      @datefrom = Date.parse param[:from]
      @dateto = Date.parse param[:to]
    end

    def dishes_data
      @dish = OrderDish
        .created_at_between(datefrom, dateto)
        .order_by_total_quantity(param[:order_by])
        .limit Settings.chart.limit.month
      dish.map{|key, _| [key.dish.name, key.total_quantity]}
    end
  end
end
