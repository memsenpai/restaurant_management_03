require "rails_helper"

feature "Admin::Bills" do
  FactoryGirl.create_list :bill, 1
  FactoryGirl.create_list :bill_detail, 2
  staff = FactoryGirl.create :staff

  before :each do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123456"
    click_button "Login"
    visit admin_bills_path
  end

  scenario "visit to Bills" do
    expect(page).to have_content "Bill code"
    expect(page).to have_content "Customer code"
    expect(page).to have_content "Voucher"
  end

  scenario "click to bill details" do
    click_link("Details", match: :first)
    expect(page).to have_content "Customer name"
    expect(page).to have_content "Customer code"
    expect(page).to have_content "Phone"
  end
end
