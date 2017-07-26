require "rails_helper"

RSpec.describe Supports::OrderSupport, type: :model do
  10.times do |time|
    FactoryGirl.create :order, time_in: time*24
  end
  orders = Supports::OrderSupport.new order: Order.all,
    param: {q: "#{Order.first.code}"}

  it{expect(orders.orders).to_not eq nil}
  it{expect(orders.orders_search).to_not eq nil}
  it{expect(orders.statuses).to_not eq nil}
  it{expect(orders.tables).to_not eq nil}
end
