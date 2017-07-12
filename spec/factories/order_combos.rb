FactoryGirl.define do
  factory :order_combo do
    quantity {Faker::Number.between 1, 10}
    order_id {Faker::Number.between 1, 10}
    combo_id {Faker::Number.between 1, 10}
    discount 0
    price 0
    total_price 0
  end
end
