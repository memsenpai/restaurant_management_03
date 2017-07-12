require "rails_helper"

RSpec.describe OrderCombo, type: :model do

  FactoryGirl.create_list(:combo, 10)
  FactoryGirl.create_list(:order, 10)
  order_c = FactoryGirl.create :order_combo

  describe "enum" do
    it{should define_enum_for :status}
  end
  describe "associations" do
    it{should belong_to :order}
    it{should belong_to :combo}
  end

  describe "validates" do
    it{should validate_presence_of :quantity}
    it do
      should validate_numericality_of(:quantity)
        .is_greater_than(0).only_integer
    end
  end

  context "method" do
    order_c.price = 0
    it{expect(order_c.original_price).to eq 0}
    it{expect(order_c.total_price).to eq 0}
  end

  context "test error" do
    it "raise error combo" do
      expect(order_c.errors.messages[:combo])
        .to_not eq ["is not valid or is not active."]
    end
    it "raise error order" do
      expect(order_c.errors.messages[:order])
        .to_not eq ["is not a valid order."]
    end
  end

  context "test finalize" do
    it{expect(order_c.price).to eq order_c.combo.price}
    it{expect(order_c.total_price).to eq order_c.quantity * order_c.price}
  end
end
