FactoryGirl.define do
  factory :discount_code do
    code {Digest::MD5.base64digest Faker::Number.between(1, 100).to_s}
    discount {Faker::Number.between 10, 20}
    status "avaiable"
  end
end
