FactoryGirl.define do
  factory :admin, class: Administrator, parent: :human do
    password "123456"
  end
end
