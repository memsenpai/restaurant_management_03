require "rails_helper"

RSpec.describe Customer, type: :model do
  customer = FactoryGirl.create :customer

  describe "associations" do
    it{should have_many :orders}
  end

  context "call back after save" do
    it{expect(customer.code).to_not eq nil}
  end
end
