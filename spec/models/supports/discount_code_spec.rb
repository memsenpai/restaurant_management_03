require "rails_helper"

RSpec.describe Supports::DiscountCodeSupport, type: :model do
  FactoryGirl.create_list :discount_code, 10
  codes = Supports::DiscountCodeSupport.new discount: DiscountCode.all,
    param: {q: "#{DiscountCode.first.code}"}
  it{expect(codes.discounts).to_not eq nil}
  it{expect(codes.discounts_search).to_not eq nil}
end
