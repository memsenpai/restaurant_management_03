require "rails_helper"
include SessionHelper

RSpec.describe SessionHelper, type: :helper do
  admin = FactoryGirl.create :admin
  guest = FactoryGirl.create :guest

  describe "log_in" do
    it{expect(log_in admin).to_not eq nil}
  end

  describe "current_admin" do
    it{expect(current_admin).to eq nil}
  end

  describe "current_order" do
    it{expect(current_order).to_not eq nil}
    order = FactoryGirl.create :order
    it{expect(current_order order.id).to_not eq nil}
  end

  describe "update_guest" do
    it{expect(update_guest guest).to_not eq nil}
  end

  describe "logged_in?" do
    it{expect(logged_in?).to eq false}
  end

  describe "log_out" do
    it{expect(log_out).to be nil}
  end
end
