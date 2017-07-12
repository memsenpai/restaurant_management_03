require "rails_helper"
include Admin::OrderHelper

RSpec.describe Admin::OrderHelper, type: :helper do
  FactoryGirl.create_list :discount_code, 100
  it "find_discount" do
    expect(find_discount DiscountCode.first.code).to_not eq nil
    expect(find_discount ".").to eq true
  end
end
