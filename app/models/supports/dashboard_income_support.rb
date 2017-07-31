module Supports
  class DashboardIncomeSupport
    attr_reader :income, :listdata, :object

    def income_data
      data = Array.new
      (2016..(Time.current.year)).each do |year|
        year_data = data_in_year year
        data << {name: year, data: year_data}
      end
      data
    end

    def data_in_year year
      @listdata = Array.new
      @object = Hash.new(0)
      (1..12).each do |month|
        cal_income_per_month month, year
      end
      add_data_list
    end

    def cal_income_per_month month, year
      thisyear = Time.zone.local(year)
      Bill
        .created_at_between(thisyear.beginning_of_year, thisyear.end_of_year)
        .in_month(month)
        .map{|key, _| object[month] += key.total}
    end

    def add_data_list
      (1..12).each do |month|
        listdata << object[month]
      end
      listdata
    end
  end
end
