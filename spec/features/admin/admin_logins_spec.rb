require "rails_helper"

feature "Admin::Logins" do
  admin = FactoryGirl.create :admin

  scenario "without email + password" do
    visit login_path
    click_button "Login"
    expect(page).to have_content "Wrong password or email"
  end

  scenario "within email + password failed" do
    visit login_path
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: "123123123"
    click_button "Login"
    expect(page).to have_content "Wrong password or email"
  end

  scenario "within email + password " do
    visit login_path
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: "123456"
    click_button "Login"
    expect(page).not_to have_content "Wrong password or email"
  end
end
