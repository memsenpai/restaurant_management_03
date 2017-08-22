module Admin
  class CustomersController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_customer, only: %i(show update destroy)
    before_action :load_require, only: :show
    before_action :load_require_index, only: :index

    def index; end

    def create
      @customer = Customer.new customer_params
      if customer.save
        render json: {data: customer}
      else
        render json: nil
      end
    end

    def show; end

    def update
      customer.update_attributes customer_params
      redirect_to :back
    end

    def destroy
      return render json: {status: 1} if customer.destroy
      render json: {status: 0}
    end

    private

    attr_reader :customer

    def customer_params
      params.require(:customer).permit :name, :email, :phone_num
    end

    def find_customer
      @customer = Customer.find_by id: params[:id]

      redirect_to admin_customers_url unless customer
    end

    def check_params
      type = params[:type]
      customer_orders = customer.orders

      return customer_orders unless type
      customer_orders.send type.downcase
    end

    def load_require
      find_customer
      @orders_support = Supports::OrderSupport.new order: check_params,
        param: params
    end

    def check_params_index
      type = params[:type]
      all_customers = Customer.all

      return all_customers unless type
      all_customers.send type.downcase
    end

    def load_require_index
      @customers = Supports::CustomerSupport
        .new customers: check_params_index, param: params
    end
  end
end
