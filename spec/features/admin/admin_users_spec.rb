require "rails_helper"

feature "Admin::Users" do
  staff = FactoryGirl.create :staff

  before :each do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123456"
    click_button "Login"
    visit admin_users_path
  end

  scenario "visit to Users" do
    expect(page).to have_link "New Admin"
  end

  scenario "click to button Create new Admin" do
    click_link "New Admin"
    expect(page).not_to have_link "New Admin"
    expect(page).to have_button "Create Admin"
  end

  scenario "click to button Create new Admin" do
    click_link "New Admin"
    expect(page).not_to have_link "New Admin"
    expect(page).to have_button "Create Admin"
  end

  scenario "Create a new Admin (failure)" do
    click_link "New Admin"
    click_button "Create Admin"
    expect(page).to have_content "New Admin"
  end

  scenario "Create a new Admin (success)" do
    click_link "New Admin"
    fill_in :staff_email, with: "admin@gmail.com"
    fill_in :staff_name, with: "administrator"
    fill_in :staff_password, with: "123123"
    fill_in :staff_password_confirmation, with: "123123"
    click_button "Create Admin"
    expect(page).not_to have_button "Create Admin"
    expect(page).to have_content "Success update info"
  end
end
