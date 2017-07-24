require "rails_helper"

RSpec.describe OrderCombo, type: :model do
  tables = FactoryGirl.create_list :table, 10
  FactoryGirl.create_list :combo, 10
  tables.map{|table| FactoryGirl.create :order, table_id: table.id}
  FactoryGirl.create_list :order, 10
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
    it{expect(order_c.original_price).to_not eq 0}
    it{expect(order_c.total_price).to_not eq 0}
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

  describe "after_update_commit" do
    it{expect(order_c.update_attributes quantity: 1).to eq true}
  end
end
