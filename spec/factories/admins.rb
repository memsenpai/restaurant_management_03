FactoryGirl.define do
  factory :admin, class: Admin, parent: :human do
    password "123456"
  end
end
