require "rails_helper"

feature "booking" do

  scenario "with full valid info" do
    visit tables_path

    fill_in "capacity_field", with: "2"
    fill_in "date_field", with: "2017-7-12"
    fill_in "timepicker", with: "10:00"
    find_button("Next", class: "first-step").click
    expect(page).to have_button "Next", class: "second-step"
  end

  scenario "with blank capacity" do
    visit tables_path

    fill_in "date_field", with: "2017-7-12"
    fill_in "timepicker", with: "10:00"
    find_button("Next", class: "first-step").click
    expect(page).to have_content "Please fill all field to select available table!"
  end

  scenario "with blank capacity and date" do
    visit tables_path

    fill_in "timepicker", with: "10:00"
    find_button("Next", class: "first-step").click
    expect(page).to have_content "Please fill all field to select available table!"
  end

  scenario "with blank info" do
    visit tables_path

    find_button("Next", class: "first-step").click
    expect(page).to have_content "Please fill all field to select available table!"
  end

  scenario "not choose table" do
    visit tables_path

    find_button("Next", class: "first-step").click
    find_button("Next", class: "second-step").click
    expect(page).to have_content "Please select your prefer table!"
  end

  scenario "choose available table" do
    visit tables_path

    find_button("Next", class: "first-step").click
    find_button("Next", class: "second-step").click
    expect(page).to have_button "Previous"
    expect(page).to have_button "Confirm"
  end

end
