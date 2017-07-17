require "rails_helper"

feature "Admin::Categories" do
  before :each do
    visit login_path
    fill_in :session_email, with: "admin@123.com"
    fill_in :session_password, with: "123123"
    click_button "Login"
    visit admin_categories_path
  end

  scenario "visit to Categories" do
    expect(page).to have_content "Awesomecity Screen Chef Manage Combo Category"
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
    category = Category.first
    visit edit_admin_category_path category
    fill_in :category_name, with: "CategoryName"
    fill_in :category_description, with: "CategoryDesciption"
    click_button "Save changes to Category"
    expect(page).not_to have_button "Save changes to Category"
    expect(page).to have_link "Edit category"
  end

  scenario "Edit a category (failure)" do
    category = Category.first
    visit edit_admin_category_path category
    fill_in :category_name, with: ""
    fill_in :category_description, with: ""
    click_button "Save changes to Category"
    expect(page).to have_button "Save changes to Category"
  end
end
