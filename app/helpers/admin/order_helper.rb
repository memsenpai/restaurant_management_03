module Admin::OrderHelper
  def find_discount param
    if param
      discount = DiscountCode.find_by code: param

      return discount if discount
      true
    end
  end
end
