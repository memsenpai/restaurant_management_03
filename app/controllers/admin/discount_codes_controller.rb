module Admin
  class DiscountCodesController < ApplicationController
    before_action :load_support
    before_action :authenticate_staff!

    load_and_authorize_resource
    skip_load_resource only: :create

    def index; end

    def create
      quantity = params[:quantity].to_i
      quantity.times do
        DiscountCode.new.update_attributes discount_params
      end
      respond_html "_item_discount_code"
    end

    def update
      unless discount_code.update_attributes discount_params
        flash[:danger] = t "staff_order.something_wrong"
      end
      respond_html "_item_discount_code"
    end

    def destroy
      if discount_code && discount_code.destroy
        redirect_to :back
      else
        flash[:danger] = t "staff_order.something_wrong"
      end
    end

    private

    attr_reader :support, :discount_code

    def discount_params
      params.require(:discount_code).permit :discount, :status, :code
    end

    def load_support
      @support = Supports::DiscountCodeSupport.new discount: DiscountCode.all,
        param: params
    end

    def respond_html link
      respond_to do |format|
        format.html{render link, layout: false, locals: {support: support}}
      end
    end
  end
end
