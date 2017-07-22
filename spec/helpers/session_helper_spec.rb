require "rails_helper"
include SessionHelper

RSpec.describe SessionHelper, type: :helper do
  staff = FactoryGirl.create :staff
  customer = FactoryGirl.create :customer

  describe "current_order" do
    it{expect(current_order).to_not eq nil}
    order = FactoryGirl.create :order
    it{expect(current_order order.id).to_not eq nil}
  end
end
