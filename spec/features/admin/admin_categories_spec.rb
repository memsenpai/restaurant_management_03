require "rails_helper"

feature "Admin::Categories" do
  staff = FactoryGirl.create :staff
  category = FactoryGirl.create :category

  before :each do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123456"
    click_button "Login"
    visit admin_categories_path
  end

  scenario "visit to Categories" do
    expect(page).to have_content "Combo Category"
  end

  scenario "click to button Add" do
    click_link "Add"
    expect(page).to have_button "Create Category"
  end

  scenario "Create a new Category (failure)" do
    click_link "Add"
    click_button "Create Category"
    expect(page).to have_button "Create Category"
  end

  scenario "Create a new Category (success)" do
    click_link "Add"
    fill_in :category_name, with: "CategoryName"
    fill_in :category_description, with: "CategoryDesciption"
    click_button "Create Category"
    expect(page).not_to have_button "Create Category"
    expect(page).to have_link "Edit category"
  end

  scenario "Edit a category (success)" do
    visit edit_admin_category_path category
    fill_in :category_name, with: "CategoryName"
    fill_in :category_description, with: "CategoryDesciption"
    click_button "Save changes to Category"
    expect(page).not_to have_button "Save changes to Category"
    expect(page).to have_link "Edit category"
  end

  scenario "Edit a category (failure)" do
    visit edit_admin_category_path category
    fill_in :category_name, with: ""
    fill_in :category_description, with: ""
    click_button "Save changes to Category"
    expect(page).to have_button "Save changes to Category"
  end
end
