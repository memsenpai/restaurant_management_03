module Api
  class OrderComboChartsController < Api::BaseController
    skip_before_action :authenticate_user_from_token

    attr_reader :data

    def index
      @data = Supports::DashboardOrderComboSupport.new param: params
      render json: {
        combos: data.combos_data
      }
    end
  end
end
