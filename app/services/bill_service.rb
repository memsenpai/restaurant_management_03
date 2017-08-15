class BillService
  def initialize param
    @order = param
  end

  def create_bill_info
    insert_dish_into_bill_detail
    insert_combo_into_bill_detail
    membership = order.customer.membership
    up_point_membership membership,
      (OrderServices.new(order).price_final / 100).to_i * membership.ratio.to_i
  end

  private

  attr_reader :order

  %w(dish combo).each_with_index do |object, index|
    define_method "insert_#{object}_into_bill_detail" do
      order.send("order_#{object.pluralize}").served.each do |item|
        order.bill.bill_details.create! id_item: item.send("#{object}_id"),
          quantity: item.quantity, price: item.price,
          item_type: index + 1, discount: item.find_discount
      end
    end
  end

  def up_point_membership membership, point_up
    membership.update_attributes point: membership.point + point_up,
      total_point: membership.total_point + point_up
  end
end
