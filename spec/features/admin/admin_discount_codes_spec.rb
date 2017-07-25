require "rails_helper"

feature "Admin::DiscountCodes" do
  staff = FactoryGirl.create :staff

  before :each do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123456"
    click_button "Login"
    visit admin_discount_codes_path
  end

  scenario "visit to discount codes" do
    expect(page).to have_content "Discount"
    expect(page).to have_content "Awesomecity Cooking"
    expect(page).to have_selector "#btn-generate-code"
  end

  scenario "click buttun Generate within discount: 0; quanlity: 0" do
    page.find("#btn-generate-code").click
    expect(page).to have_selector "#btn-generate-code"
  end
end
