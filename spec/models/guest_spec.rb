require "rails_helper"

RSpec.describe Guest, type: :model do
  describe "associations" do
    it{should have_many :orders}
  end

  # describe "callback" do
  #   it{should use_after_action :generate_code}
  # end
  context "call back after save" do
    guest = Guest.create name: Faker::Name.name,
    email: Faker::Internet.email
  end
end
