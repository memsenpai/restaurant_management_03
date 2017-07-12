require "rails_helper"

RSpec.describe Combo, type: :model do
  describe "associations" do
    it{should have_many :combo_dishes}
    it{should have_many(:dishes).through(:combo_dishes).dependent :destroy}
    it{should have_many :order_combos}
  end

  describe "validates" do
    it{should validate_presence_of :name}
    it{should validate_presence_of :discount}
    it{should validate_numericality_of(:discount).is_greater_than 0}
  end

  combos = Combo.popular_combos
  combo = FactoryGirl.create :combo
  combo.discount = 0
  it{expect(combos).to_not include combo}
  it{expect(combo.subtotal).to eq 0}
  it{expect(combo.price).to eq 0}
end
