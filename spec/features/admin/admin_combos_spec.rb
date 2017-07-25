require "rails_helper"

feature "Admin::Combos" do
  staff = FactoryGirl.create :staff
  combo = FactoryGirl.create :combo

  before :each do
    visit login_path
    fill_in :staff_email, with: staff.email
    fill_in :staff_password, with: "123456"
    click_button "Login"
    visit admin_combos_path
  end

  scenario "visit to combos" do
    expect(page).to have_content "Manage Combo"
  end

  scenario "check list combos" do
    visit admin_combos_path
    expect(page).to have_selector "#di_row_0"
  end

  scenario "click to button Create combo" do
    click_link "Create new Combo"
    expect(page).to have_button "Create Combo"
  end

  scenario "Create a new combo (success)" do
    click_link "Create new Combo"
    fill_in :combo_name, with: "Namecombo"
    fill_in :combo_description, with: "combo_description"
    fill_in :combo_discount, with: "30"
    fill_in :combo_image, with: "img.jpg"
    click_button "Create Combo"
    expect(page).to have_link "Edit combo"
  end

  scenario "Create a new combo (failure)" do
    click_link "Create new Combo"
    click_button "Create Combo"
    expect(page).to have_button "Create Combo"
  end

  scenario "Edit a combo (failure)" do
    visit edit_admin_combo_path combo
    fill_in :combo_name, with: nil
    click_button "Save changes to Combo"
    expect(page).to have_button "Save changes to Combo"
  end

  scenario "Edit a combo (success)" do
    visit edit_admin_combo_path combo
    click_button "Save changes to Combo"
    expect(page).not_to have_button "Save changes to Combo"
    expect(page).to have_link "Edit combo"
  end
end
