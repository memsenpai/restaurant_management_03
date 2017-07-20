require "rails_helper"

feature "Admin::Bills" do
  FactoryGirl.create_list :bill, 1
  FactoryGirl.create_list :bill_detail, 2
  admin = FactoryGirl.create :admin

  before :each do
    visit login_path
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: "123456"
    click_button "Login"
    visit admin_bills_path
  end

  scenario "visit to Bills" do
    expect(page).to have_content "Bill code"
    expect(page).to have_content "Guest code"
    expect(page).to have_content "Voucher"
  end

  scenario "click to bill details" do
    click_link("Details", match: :first)
    expect(page).to have_content "Guest name"
    expect(page).to have_content "Guest code"
    expect(page).to have_content "Phone"
  end
end
