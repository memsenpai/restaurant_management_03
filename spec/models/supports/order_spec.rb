require "rails_helper"

RSpec.describe Supports::OrderSupport, type: :model do
  FactoryGirl.create_list :order, 10
  orders = Supports::OrderSupport.new order: Order.all,
    param: {q: "#{Order.first.code}"}
  it{expect(orders.orders).to_not eq nil}
  it{expect(orders.orders_search).to_not eq nil}
end
