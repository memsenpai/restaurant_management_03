class BillService
  def initialize param
    @order = param
  end

  def create_bill_info
    return if order.bill
    order_customer = order.customer
    order.create_bill! customer_id: order_customer.id,
      discount: order.discount,
      membership_discount: order_customer.membership_discount
    process_bill
  end

  private

  attr_reader :order

  def process_bill
    insert_dish_into_bill_detail
    insert_combo_into_bill_detail
    order_customer = order.customer
    order_customer
      .update_attributes money_paid: order_customer
        .money_paid + order.price_final
  end

  %w(dish combo).each_with_index do |object, index|
    define_method "insert_#{object}_into_bill_detail" do
      order.send("order_#{object.pluralize}").served.each do |item|
        order.bill.bill_details.create! id_item: item.send("#{object}_id"),
          quantity: item.quantity, price: item.price,
          item_type: index + 1, discount: item.find_discount
      end
    end
  end
end
