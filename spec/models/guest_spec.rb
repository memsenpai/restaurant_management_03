require "rails_helper"

RSpec.describe Guest, type: :model do
  guest = FactoryGirl.create :guest

  describe "associations" do
    it{should have_many :orders}
  end

  context "call back after save" do
    it{expect(guest.code).to_not eq nil}
  end
end
