require "rails_helper"

RSpec.describe Staff, type: :model do
  staff = FactoryGirl.create :staff

  describe "after_initialize" do
    it{expect(staff.staff_role).to  eq "administrator"}
  end

  describe "method" do
    it{expect(Staff.roles_select).to_not be eq nil}
    it{expect(staff.role).to eq "Administrator"}
  end

  describe "valid custom" do
    it{expect(staff.valid_for_custom_authentication? "123456").to eq true}
  end

  it "auto generate auth token" do
    staff.save
    expect(staff.authentication_token).to_not be_empty
  end

  it "generate new auth token" do
    staff.save
    old_token = staff.authentication_token
    staff.generate_new_token
    new_token = staff.authentication_token
    expect(old_token).to_not eq(new_token)
  end
end
