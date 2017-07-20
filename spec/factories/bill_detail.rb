FactoryGirl.define do
  factory :bill_detail do
    id_item {FactoryGirl.create(:dish).id}
    item_type 1
    quantity {Faker::Number.between(1, 10)}
    discount {Faker::Number.between(0, 100)}
    price {Faker::Number.between(0, 100)}
    bill_id {Faker::Number.between(1, 10)}
  end
end
