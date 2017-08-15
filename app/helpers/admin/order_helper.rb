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

    def ratio membership
      MembershipLevel.ratio(membership.total_point).round 2
    end

    def validate_point? point_used, point_have, price
      point_used <= point_have && point_used <= price && point_used > 0
    end
  end
end
