require "rails_helper"

RSpec.describe Promo, type: :model do
  dish = FactoryGirl.create :dish
  promo = FactoryGirl.create :promo, dish_id: dish.id

  describe "scope" do
    it{expect(Promo.find_discount promo.id, Time.now, Time.now).to_not eq nil}
  end

  describe "method" do
    it{expect(promo.is_available?).to eq true}
  end
end
