FactoryGirl.define do
  factory :table do
    capacity {Faker::Number.between(1, 10)*2}
  end
end
