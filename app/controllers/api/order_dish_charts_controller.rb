module Api
  class OrderDishChartsController < Api::BaseController
    skip_before_action :authenticate_user_from_token

    attr_reader :data

    def index
      @data = Supports::DashboardOrderDishSupport.new param: params
      render json: {
        dishes: data.dishes_data
      }
    end
  end
end
