module Admin
  module OrderHelper
    def find_discount param
      return unless param
      discount = DiscountCode.find_by code: param

      return discount if discount
      true
    end

    def change_status order
      OrderServices.new(order).change_status
    end

    def order_services order
      OrderServices.new order
    end
  end
end
