FactoryGirl.define do
  factory :human do
    name {Faker::Name.name}
    email {Faker::Internet.email}
  end
end
