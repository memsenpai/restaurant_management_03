FactoryGirl.define do
  factory :bill do
    guest {FactoryGirl.create :guest}
    order {FactoryGirl.create :order}
    discount {Faker::Number.between(0, 100)}
  end
end
