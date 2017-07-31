module Api
  class TimeinChartsController < Api::BaseController
    skip_before_action :authenticate_user_from_token

    attr_reader :data

    def index
      @data = Supports::DashboardTimeinSupport.new param: params
      render json: {
        timein: data.timein_data
      }
    end
  end
end
