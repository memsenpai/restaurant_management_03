FactoryGirl.define do
  factory :bill do
    customer {FactoryGirl.create :customer}
    order {FactoryGirl.create :order}
    discount {Faker::Number.between(0, 100)}
  end
end
