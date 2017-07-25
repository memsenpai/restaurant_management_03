require "rails_helper"

feature "Admin::Logins" do
  staff = FactoryGirl.create :staff

  scenario "without email + password" do
    visit login_path
    click_button "Login"
    expect(page).to have_button "Login"
  end

  scenario "within email + password failed" do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123123123"
    click_button "Login"
    expect(page).to have_button "Login"
  end

  scenario "within email + password success" do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123456"
    click_button "Login"
    expect(page).not_to have_content "Wrong password or email"
  end
end
