module Api
  class OrdersController < Api::BaseController
    before_action :find_order, only: %i(show update destroy)

    def index
      render json: Order.serving.first
    end

    def show
      render json: order
    end

    private

    attr_reader :order, :orders

    def find_order
      @order = Order.find_by id: params[:id]
      return if order
      render nothing: true, status: :not_found
    end
  end
end
