module Admin
  module OrderHelper
    def find_discount param
      return unless param
      discount = DiscountCode.find_by code: param

      return discount if discount
      true
    end
  end
end
