require "rails_helper"

RSpec.describe Order, type: :model do
  order = FactoryGirl.create :order
  order_dish = FactoryGirl.create :order_dish, order_id: order.id
  FactoryGirl.create :order_combo, order_id: order.id
  FactoryGirl.create :promo, dish_id: order_dish.dish_id,
    end_day: Faker::Time.forward, end_time: Faker::Time.forward

  describe "associations" do
    it{should belong_to :customer}
    it{should belong_to(:table).inverse_of :orders}

    it{should have_many :order_dishes}
    it{should have_many :order_combos}

    it{should accept_nested_attributes_for :customer}
    it{should accept_nested_attributes_for :table}
  end

  describe "delegate" do
    it{should delegate_method(:capacity).to :table}
  end

  context "call back after_save" do
    it{expect(order.code).to_not eq nil}
  end

  context "method" do
    it{expect(order.subtotal).to_not eq 0}
    it{expect(order.original_price).to_not eq 0}
  end

end
