require "rails_helper"

feature "Admin::Profile" do
  admin = FactoryGirl.create :admin

  before :each do
    visit login_path
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: "123456"
    click_button "Login"
    visit edit_admin_path
  end

  scenario "visit to edit profile" do
    expect(page).not_to have_button "Login"
  end

  scenario "Update profile (Success)" do
    fill_in :admin_old_password, with: "123456"
    click_button "Update profile"
    expect(page).not_to have_button "Update profile"
  end

  scenario "Update profile (failure)" do
    fill_in :admin_name, with: ""
    fill_in :admin_email, with: ""
    click_button "Update profile"
    expect(page).to have_button "Update profile"
  end

  scenario "Check logout" do
    visit admin_path
    click_link "Log out"
    expect(page).not_to have_link "Log out"
    expect(page).to have_content "Awesomecity Home"
  end
end
