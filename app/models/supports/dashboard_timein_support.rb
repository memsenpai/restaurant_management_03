module Supports
  class DashboardTimeinSupport
    attr_reader :param, :datefrom, :dateto, :timein

    def initialize arg
      @param = arg[:param]
      @datefrom = Date.parse param[:from]
      @dateto = Date.parse param[:to]
    end

    def timein_data
      @timein = Order.all.timein_between(datefrom, dateto)
        .order_by_timein(param[:order_by]) - Order.declined
      respond_timein_data
    end

    def respond_timein_data
      timein.map do |key, _|
        [(Time.current.to_date.to_s + " " + key.time_in)
          .in_time_zone.to_i * 1000, key.times]
      end
    end
  end
end
