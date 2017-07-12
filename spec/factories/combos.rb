FactoryGirl.define do
  factory :combo do
    name {Faker::Name.title}
    discount {Faker::Number.between 1, 20}
  end
end
