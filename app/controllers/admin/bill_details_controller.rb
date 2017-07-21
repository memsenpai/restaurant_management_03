module Admin
  class BillDetailsController < ApplicationController
    before_action :authenticate_staff!

    def create
      @bill_detail = BillDetail.new bill_detail_params

      return render json: {status: 1} if bill_detail.save
      render json: {status: 0}
    end

    private

    attr_reader :bill_detail

    def bill_detail_params
      params.require(:bill_detail).permit :id_item, :price,
        :discount, :quantity, :item_type, :bill_id
    end
  end
end
