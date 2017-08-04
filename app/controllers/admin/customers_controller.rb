module Admin
  class CustomersController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_customer, only: %i(show update destroy)

    def index
      @customers = Supports::CustomerSupport
        .new customers: Customer.all, param: params
    end

    def create
      @customer = Customer.new customer_params
      if customer.save
        render json: {data: customer}
      else
        render json: nil
      end
    end

    def update
      return render json: {status: 1} if customer
        .update_attributes customer_params
      render json: {status: 0}
    end

    def destroy
      return render json: {status: 1} if customer.destroy
      render json: {status: 0}
    end

    private

    attr_reader :customer

    def customer_params
      params.require(:customer).permit :name, :email,
        :phone_num, :warning_times, :code, :money_paid
    end

    def find_customer
      @customer = Customer.find_by id: params[:id]

      redirect_to admin_customers_url unless customer
    end
  end
end
