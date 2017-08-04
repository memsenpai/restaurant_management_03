module Supports
  class DashboardOrderComboSupport
    attr_reader :param, :datefrom, :dateto, :combo

    def initialize arg
      @param = arg[:param]
      @datefrom = Date.parse param[:from]
      @dateto = Date.parse param[:to]
    end

    def combos_data
      @combo = OrderCombo
        .created_at_between(datefrom, dateto)
        .order_by_total_quantity(param[:order_by])
        .limit Settings.chart.limit.month
      combo.map{|key, _| [key.combo.name, key.total_quantity]}
    end
  end
end
