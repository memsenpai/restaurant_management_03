module Api
  class IncomeChartsController < Api::BaseController
    skip_before_action :authenticate_user_from_token

    attr_reader :data

    def index
      @data = Supports::DashboardIncomeSupport.new
      render json: {income: data.income_data}
    end
  end
end
