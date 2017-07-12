require "rails_helper"

RSpec.describe DiscountCode, type: :model do
  discount = FactoryGirl.create :discount_code
  it{expect(discount.code).to_not eq nil}
end
