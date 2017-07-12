FactoryGirl.define do
  factory :dish do
    name {Faker::Name.title}
    price {Faker::Number.between 1, 100}
    is_available true
  end
end
