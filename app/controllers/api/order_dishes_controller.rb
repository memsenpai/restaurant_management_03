module Api
  class OrderDishesController < Api::BaseController
    before_action :find_order
    before_action :find_order_dishes, except: %i(index)

    def index
      render json: order.order_dishes.all
    end

    def show
      render json: order_dishes
    end

    def update
      if order_dishes.update_attributes status: params[:order_dish][:status]
        render json: nil, status: :ok
      else
        render json: nil, status: :not_found
      end
    end

    private

    attr_reader :order, :order_dishes

    def find_order
      @order = Order.find_by id: params[:order_id]

      return if order
      render json: Array.new, status: :not_found
    end

    def find_order_dishes
      @order_dishes = order.order_dishes.find_by id: params[:id]

      return if order_dishes
      render json: Array.new, status: :not_found
    end
  end
end
