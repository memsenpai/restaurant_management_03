require "rails_helper"

RSpec.describe Admin, type: :model do
  admin = FactoryGirl.create :admin
  describe "enum" do
    it{should define_enum_for :admin_role}
  end

  describe "validates" do
    it{should validate_presence_of :password}
    it{should validate_length_of(:password).is_at_least(6)}
  end
  describe "after_initialize" do
    it{expect(admin.admin_role).to  eq "administrator"}
  end

  describe "method" do
    it{expect(Admin.roles_select).to_not be eq nil}
    it{expect(admin.role).to eq "Administrator"}
  end
end
