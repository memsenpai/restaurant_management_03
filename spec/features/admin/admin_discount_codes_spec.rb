require "rails_helper"

feature "Admin::DiscountCodes" do
  before :each do
    visit login_path
    fill_in :session_email, with: "admin@123.com"
    fill_in :session_password, with: "123123"
    click_button "Login"
    visit admin_discount_codes_path
  end

  scenario "visit to discount codes" do
    expect(page).to have_content "All discount"
    expect(page).to have_content "Generate new code"
    expect(page).to have_selector "#btn-generate-code"
  end

  scenario "click buttun Generate within discount: 0; quanlity: 0" do
    page.find("#btn-generate-code").click
    expect(page).to have_selector "#btn-generate-code"
  end
end
