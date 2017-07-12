require "rails_helper"

RSpec.describe Dish, type: :model do
  describe "association" do
    it{should have_many :category_dishes}
    it do
      should have_many(:categories).through(:category_dishes)
        .dependent :destroy
    end
    it{should have_many :combo_dishes}
    it{should have_many(:combos).through(:combo_dishes).dependent :destroy}
    it{should have_many :order_dishes}
  end

  describe "validates" do
    it{should validate_presence_of :name}
    it{should validate_presence_of :price}
    it{should validate_numericality_of :price}
  end

  dish_test = FactoryGirl.create :dish
  dish = Dish.dishes
  it{expect(dish).to include dish_test}
  dish_popular = Dish.popular_dishes
  it{expect(dish_popular).to_not include Dish.new}
end
