FactoryGirl.define do
  factory :order_dish do
    quantity {Faker::Number.between 1, 10}
    order_id {Faker::Number.between 1, 10}
    dish_id {Faker::Number.between 1, 15}
    created_at {Faker::Date.between(1.years.ago, Date.today)}
  end
end
