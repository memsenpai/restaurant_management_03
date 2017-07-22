FactoryGirl.define do
  factory :customer do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    phone_num {Faker::PhoneNumber.cell_phone}
  end
end
