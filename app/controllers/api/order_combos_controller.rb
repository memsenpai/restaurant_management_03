module Api
  class OrderCombosController < Api::BaseController
    before_action :find_order
    before_action :find_order_combos, except: %i(index)

    def index
      render json: order.order_combos.all
    end

    def show
      render json: order_combos
    end

    def update
      if order_combos.update_attributes status: params[:order_combo][:status]
        render json: nil, status: :ok
      else
        render json: nil, status: :not_found
      end
    end

    private

    attr_reader :order, :order_combos

    def find_order
      @order = Order.find_by id: params[:order_id]

      return if order
      render json: Array.new, status: :not_found
    end

    def find_order_combos
      @order_combos = order.order_combos.find_by id: params[:id]

      return if order_combos
      render json: Array.new, status: :not_found
    end
  end
end
