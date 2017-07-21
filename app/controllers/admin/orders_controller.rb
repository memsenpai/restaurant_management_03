module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_staff!
    before_action :check_for_cancel
    before_action :find_order, only: %i(edit update destroy)%i(index new create).freeze

    load_and_authorize_resource

    def index
      @orders_support = Supports::OrderSupport.new order: Order.all,
        param: params
      @tables = Table.all
    end

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
        flash[:success] = t "flash.order.update_success"
        redirect_to admin_orders_path
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
      respond_html_json
      redirect_to :back
    end

    private

    attr_reader :order

    def order_params
      params.require(:order).permit :discount, :day, :time_in, :is_confirm,
        customer_attributes: %i(id name).freeze,
        table_attributes: %i(id capacity).freeze
    end

    def check_for_cancel
      redirect_to admin_orders_path if params[:commit] == %w(Cancel)
    end

    def find_order
      @order = Order.find_by id: params[:id]
      redirect_to admin_orders_path unless order
    end

    def respond_html_json
      respond_to do |format|
        format.html{redirect_to :back}
        format.json{head :no_content}
      end
    end
  end
end
