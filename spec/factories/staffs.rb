FactoryGirl.define do
  factory :staff do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password "123456"
    staff_role {Faker::Number.between(0, 3)}
    created_at {Faker::Date.between(1.years.ago, Date.today)}
  end
end
