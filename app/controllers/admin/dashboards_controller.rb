module Admin
  class DashboardsController < ApplicationController
    before_action :authenticate_staff!

    def index
      @info_data = Supports::DashboardStatisticSupport.new
    end
  end
end
