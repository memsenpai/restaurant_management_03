module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_staff!
    before_action :check_for_cancel
    before_action :load_require, only: %i(index edit update)

    load_and_authorize_resource
    skip_load_resource only: %i(index)

    def index; end

    def show
      @support = Supports::DiscountCodeSupport.new discount: params[:discount]
    end

    def new
      @order = Order.new
    end

    def create
      @order = Order.new order_params

      if order.save
        flash[:success] = t "flash.order.create_success"
        redirect_to admin_order_path order
      else
        render :new
      end
    end

    def edit; end

    def update
      if order.update_attributes order_params
        change_status
        respond_to_any
      else
        render :edit
      end
    end

    def destroy
      if order.destroy
        flash[:success] = t "flash.order.delete_success"
      else
        flash[:danger] = t "flash.order.delete_fail"
      end
      respond_to_any
    end

    private

    attr_reader :order, :orders_support

    def check_params
      type = params[:type]
      return Order.all unless type
      Order.send type.downcase
    end

    def load_require
      @orders_support = Supports::OrderSupport.new order: check_params,
        param: params
    end

    def params_define
      list_param = %w(discount day time_in)
      list_param.push %w(status) if disable_status order
    end

    def order_params
      params.require(:order).permit *params_define,
        customer_attributes: %i(id name).freeze,
        table_attributes: %i(id capacity).freeze
    end

    def check_for_cancel
      redirect_to admin_orders_path if params[:commit] == %w(Cancel)
    end

    def change_status
      return unless order.status == "serving"
      order.order_dishes.map(&:needing!)
      order.order_combos.map(&:needing!)
    end

    def respond_to_any
      respond_to do |format|
        format.js
        format.html{redirect_to admin_orders_path}
      end
    end
  end
end
