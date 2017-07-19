require "rails_helper"

RSpec.describe Admin, type: :model do
  admin = FactoryGirl.create :admin

  describe "after_initialize" do
    it{expect(admin.admin_role).to  eq "administrator"}
  end

  describe "method" do
    it{expect(Administrator.roles_select).to_not be eq nil}
    it{expect(admin.role).to eq "Administrator"}
  end
end
