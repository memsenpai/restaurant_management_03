require "rails_helper"

RSpec.describe Supports::AdminDishSupport, type: :model do
  FactoryGirl.create_list :dish, 10
  ad_dish = Supports::AdminDishSupport.new dish: Dish.all, param: {q: "a"}
  it{expect(ad_dish.dishes).to_not eq nil}
  it{expect(ad_dish.dishes_search).to_not eq nil}
end
