FactoryGirl.define do
  factory :order_combo do
    quantity {Faker::Number.between 1, 10}
    order_id {Faker::Number.between 1, 10}
    combo_id {Faker::Number.between 1, 15}
    created_at {Faker::Date.between(1.years.ago, Date.today)}
  end
end
