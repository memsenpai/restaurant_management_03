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
      combos = OrderCombo.where combo_id: order_combos.combo_id,
        status: order_combos.status
      if combos
        update_combo combos
        render json: nil, status: :ok
      else
        render json: nil, status: :not_found
      end
    end

    private

    attr_reader :order, :order_combos

    def order_combo_params
      params.require(:order_combo).permit OrderCombo::ATTRIBUTES
    end

    def find_order
      @order = Order.find_by id: params[:order_id]

      return if order
      render json: Array.new, status: :not_found
    end

    def find_order_combos
      @order_combos = OrderCombo.find_by id: params[:id]

      return if order_combos
      render json: Array.new, status: :not_found
    end

    def check_status_items_in_order? order
      order.order_combos.map do |item|
        next if item.served? || item.cancel?
        break false
      end
    end

    def change_status order_combo
      order = Order.find_by id: order_combo.order_id

      return unless check_status_items_in_order? order
      order.done!
    end

    def update_combo combos
      combos.map do |combo|
        combo.update_attributes order_combo_params
        change_status combo
      end
    end
  end
end
