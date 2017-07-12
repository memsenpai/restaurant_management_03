FactoryGirl.define do
  factory :category do
    name {Faker::Name.title}
    description {Faker::Hacker.say_something_smart}
  end
end
