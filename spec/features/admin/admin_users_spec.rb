require "rails_helper"

feature "Admin::Users" do
  before :each do
    visit login_path
    fill_in :session_email, with: "admin@123.com"
    fill_in :session_password, with: "123123"
    click_button "Login"
    visit admin_users_path
  end

  scenario "visit to Users" do
    expect(page).to have_link "Create new admin"
  end

  scenario "click to button Create new Admin" do
    click_link "Create new admin"
    expect(page).not_to have_link "Create new admin"
    expect(page).to have_button "Create Admin"
  end

  scenario "click to button Create new Admin" do
    click_link "Create new admin"
    expect(page).not_to have_link "Create new admin"
    expect(page).to have_button "Create Admin"
  end

  scenario "Create a new Admin (failure)" do
    click_link "Create new admin"
    click_button "Create Admin"
    expect(page).not_to have_link "Create new admin"
    expect(page).to have_button "Create Admin"
  end

  scenario "Create a new Admin (success)" do
    click_link "Create new admin"
    fill_in :admin_email, with: "admin@gmail.com"
    fill_in :admin_name, with: "administrator"
    fill_in :admin_password, with: "123123"
    fill_in :admin_password_confirmation, with: "123123"
    click_button "Create Admin"
    expect(page).not_to have_button "Create Admin"
    expect(page).to have_content "Success update info"
  end
end
