require "rails_helper"

feature "Seach for food" do
  before :each do
    Combo.all.destroy_all

    Combo.create!(name: "Combo set 1", description: "About this food",
      image: "combo-image.jpg", discount: 10,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo set 2", description: "About this food",
      image: "combo-image.jpg", discount: 60,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo set A2", description: "But this contain
      apple",  image: "combo-image.jpg", discount: 31,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo set B1", description: "About this food",
      image: "combo-image.jpg", discount: 9,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo food set A1 2", description: "About this food",
      image: "combo-image.jpg", discount: 6,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo food 1", description: "About this food",
      image: "combo-image.jpg", discount: 15,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo bocom food", description: "But this contain apple",
      image: "combo-image.jpg", discount: 14,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo hot food 11", description: "About this food",
      image: "combo-image.jpg", discount: 40,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
  end

  scenario "with right food name" do
    visit combos_path
    fill_in :searchinput, with: "Combo food"
    click_button "Search"
    expect(page).to have_content "Combo food set A1 2"
    expect(page).to have_content "Combo food 1"
    expect(page).not_to have_content "Combo set B1"
  end

  scenario "with unavailable food name" do
    visit combos_path
    fill_in :searchinput, with: "orange"
    click_button "Search"
    expect(page).to have_content "No entries found"
  end

end
