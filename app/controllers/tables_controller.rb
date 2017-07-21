class TablesController < ApplicationController
  def index
    @customer = Customer.new
    @tables = check_table
    respond_html_json
  end

  private

  attr_reader :tables

  def table_params
    params.require(:table).permit :orders_day_eq, :capacity_gteq,
      :orders_time_in_eq
  end

  def load_info_table
    timein = DateTime.parse(table_params[:orders_time_in_eq]).in_time_zone
    hour = 2.hours
    {
      time_in_before: (timein + hour).strftime("%H:%M"),
      time_in_after: (timein - hour).strftime("%H:%M")
    }
  end

  def check_table
    if params[:table].present?
      info = load_info_table
      Table.find_table table_params[:capacity_gteq],
        table_params[:orders_day_eq], info[:time_in_before],
        info[:time_in_after]
    else
      Table.all
    end
  end

  def respond_html_json
    respond_to do |format|
      format.html
      format.json{render json: tables}
    end
  end
end
