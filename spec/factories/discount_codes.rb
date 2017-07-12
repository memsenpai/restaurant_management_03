FactoryGirl.define do
  factory :discount_code do
    code {Faker::Code.asin[4..-1]}
    discount {Faker::Number.between 10, 20}
    status "avaiable"
  end
end
