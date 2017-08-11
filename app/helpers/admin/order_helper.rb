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

    def array_opition_chef_reason_cancel
      [
        t("opition_select_chef_modal_1"),
        t("opition_select_chef_modal_2"),
        t("opition_select_chef_modal_3"),
        t("opition_select_chef_modal_4")
      ]
    end
  end
end
