FactoryGirl.define do
  factory :order do
    guest_id {Faker::Code.asin[4..-1]}
    table_id {Faker::Number.between 1, 10}
    code {Faker::Code.asin[4..-1]}
    day {Faker::Time.between DateTime.now + 1, DateTime.now + 3}
    time_in {Faker::Time.forward.hour.to_s << ":00"}
    is_confirm true
    discount 0
  end
end
