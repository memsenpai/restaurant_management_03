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
      dishes = OrderDish.where dish_id: order_dishes.dish_id,
        status: order_dishes.status
      if dishes
        update_dish dishes
        render json: nil, status: :ok
      else
        render json: nil, status: :not_found
      end
    end

    private

    attr_reader :order, :order_dishes

    def order_dish_params
      params.require(:order_dish).permit OrderDish::ATTRIBUTES
    end

    def find_order
      @order = Order.find_by id: params[:order_id]

      return if order
      render json: Array.new, status: :not_found
    end

    def find_order_dishes
      @order_dishes = OrderDish.find_by id: params[:id]

      return if order_dishes
      render json: Array.new, status: :not_found
    end

    def check_status_items_in_order? order
      order.order_dishes.map do |item|
        next if item.served? || item.cancel?
        break false
      end
    end

    def change_status order_dish
      order = Order.find_by id: order_dish.order_id

      return unless check_status_items_in_order? order
      order.done!
    end

    def update_dish dishes
      dishes.map do |dish|
        dish.update_attributes order_dish_params
        change_status dish
      end
    end
  end
end
