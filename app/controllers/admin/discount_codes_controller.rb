class Admin
  class DiscountCodesController < ApplicationController
    before_action :load_support

    def index
    end

    def create
      quantity = params[:quantity].to_i
      quantity.times do
        DiscountCode.new.update_attributes discount_params
      end
      link = "_item_discount_code"
      respond_to do |f|
        f.html{render link, layout: false, locals: {support: @support}}
      end
    end

    def update
      discount = find_discount_by_id
      unless discount.update_attributes discount_params
        flash[:danger] = t "admin_order.something_wrong"
      end
      link = "_item_discount_code"
      respond_to do |f|
        f.html{render link, layout: false, locals: {support: @support}}
      end
    end

    def destroy
      discount = find_discount_by_id
      if discount && discount.destroy
        redirect_to :back
      else
        flash[:danger] = t "admin_order.something_wrong"
      end
    end

    private
    def discount_params
      params.require(:discount_code).permit :discount, :status, :code
    end

    def load_support
      @support = Supports::DiscountCode.new discount: DiscountCode.all,
        param: params
    end

    def find_discount_by_id
      discount = DiscountCode.find_by id: params[:id]
      if discount
        discount
      else
        flash[:danger] = t "admin_order.something_wrong"
      end
    end
  end
end
