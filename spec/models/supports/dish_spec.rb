require "rails_helper"

RSpec.describe Supports::DishSupport, type: :model do
  FactoryGirl.create_list :dish, 10
  dish = Supports::DishSupport.new dish: Dish.all, param: {q: "a"}
  it{expect(dish.dishes).to_not eq nil}
  it{expect(dish.dishes_search).to_not eq nil}
end
