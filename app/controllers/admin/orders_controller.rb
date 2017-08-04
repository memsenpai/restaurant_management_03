module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_staff!
    before_action :check_for_cancel
    before_action :load_require, only: %i(index edit update)
    before_action :find_order, only: :show

    load_and_authorize_resource
    skip_load_resource only: %i(index)

    def index; end

    def show
      @membership_coupons = Supports::MembershipCouponSupport
        .new(membership_coupons: MembershipCoupon.all, param: params)
        .filter_active
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
      return unless order.uncheck? || order.approved?
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

    def find_order
      @order = Order.find_by id: params[:id]
      redirect_to admin_orders_path unless order
    end

    def order_params
      params.require(:order).permit Order::ORDER_ATTRIBUTES
    end

    def check_for_cancel
      redirect_to admin_orders_path if params[:commit] == %w(Cancel)
    end

    def change_status
      order.customer.increase_warning if order.declined?
      return unless order.serving?
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
