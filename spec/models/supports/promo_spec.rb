require "rails_helper"

RSpec.describe Supports::PromoSupport, type: :model do
  dishes = FactoryGirl.create_list :dish, 10
  dishes.map{|dish| FactoryGirl.create :promo, dish_id: dish.id}
  promos = Supports::PromoSupport.new promos: Promo.all, param: {q: "1"}
  describe "method" do
    it{expect(promos.dishes).to_not eq nil}
    it{expect(promos.promos_search).to_not eq nil}
  end
end
