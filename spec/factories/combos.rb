FactoryGirl.define do
  factory :combo do
    name {Faker::Name.title}
    image "https://d1sttufwfa12ee.cloudfront.net/uploads/deal/thumb/49029_3.jpg"
    discount {Faker::Number.between 1, 20}
  end
end
