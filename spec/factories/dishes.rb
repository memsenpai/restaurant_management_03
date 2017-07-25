FactoryGirl.define do
  factory :dish do
    name {Faker::Name.title}
    price {Faker::Number.between 1, 100}
    image "http://images.media-allrecipes.com/images/57796.jpg"
    is_available true
  end
end
