FactoryGirl.define do
  factory :promo do
    dish_id {Faker::Number.between 1, 10}
    discount {Faker::Number.between 1, 100}
    start_time {Faker::Time.backward 1, :morning}
    end_time {Faker::Time.forward 1, :morning}
    start_day {Faker::Time.backward 1, :morning}
    end_day {Faker::Time.forward 1, :morning}
  end
end
