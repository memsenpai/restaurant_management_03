FactoryGirl.define do
  factory :staff do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password "123456"
  end
end
