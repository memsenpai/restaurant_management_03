require "rails_helper"

RSpec.describe OrderDish, type: :model do
  tables = FactoryGirl.create_list :table, 10
  FactoryGirl.create_list :dish, 10
  tables.map{|table| FactoryGirl.create :order, table_id: table.id}
  od = FactoryGirl.create :order_dish
  FactoryGirl.create :promo, dish_id: od.dish_id,
    end_day: Faker::Time.forward, end_time: Faker::Time.forward

  describe "enum" do
    it{should define_enum_for :status}
  end

  describe "associations" do
    it{should belong_to :order}
    it{should belong_to :dish}
  end

  describe "validates" do
    it{should validate_presence_of :quantity}
    it do
      should validate_numericality_of(:quantity)
        .is_greater_than(0).only_integer
    end
  end

  describe "before_save" do
   it{expect(od.price).to eq od.dish.price}
   it{expect(od.total_price).to eq od.quantity * od.price}
  end

  describe "total_price" do
    od.quantity = 0
    it{expect(od.total_price).to eq 0}
  end

  describe "validate custom" do
    it{expect(od.errors.messages[:dish]).to eq []}
    it{expect(od.errors.messages[:order]).to eq []}
  end

  describe "after_update_commit" do
    it{expect(od.update_attributes quantity: 1).to eq true}
  end
end
