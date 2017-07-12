require "rails_helper"

feature "filter combos" do
  before :each do
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
    Combo.create!(name: "Combo set A1 2", description: "About this food",
      image: "combo-image.jpg", discount: 6,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo food 1", description: "About this food",
      image: "combo-image.jpg", discount: 15,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo bocom", description: "But this contain apple",
      image: "combo-image.jpg", discount: 14,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
    Combo.create!(name: "Combo hot 11", description: "About this food",
      image: "combo-image.jpg", discount: 40,
      from: "2017-04-07 00:00:00", to: "2017-04-14 00:00:00")
  end

  scenario "order price desc" do
    visit combos_path
    click_link "Discount"

    within ".deal:nth-child(1) h1:first-of-type" do
      expect(page).to have_content "Combo set 2"
    end

    within ".deal:nth-child(2) h1:first-of-type" do
      expect(page).to have_content "Combo hot 11"
    end

    within ".deal:nth-child(3) h1:first-of-type" do
      expect(page).to have_content "Combo set A2"
    end

    within ".deal:nth-child(4) h1:first-of-type" do
      expect(page).to have_content "Combo food 1"
    end

  end

  scenario "order price asc" do
    visit combos_path
    click_link "Discount"
    click_link "Discount"

    within ".deal:nth-child(1) h1:first-of-type" do
      expect(page).to have_content "Combo set A1 2"
    end

    within ".deal:nth-child(2) h1:first-of-type" do
      expect(page).to have_content "Combo set B1"
    end

    within ".deal:nth-child(3) h1:first-of-type" do
      expect(page).to have_content "Combo set 1"
    end

    within ".deal:nth-child(4) h1:first-of-type" do
      expect(page).to have_content "Combo bocom"
    end

  end

  scenario "order name desc" do
    visit combos_path
    click_link "Name"

    within ".deal:nth-child(1) h1:first-of-type" do
      expect(page).to have_content "Combo set B1"
    end

    within ".deal:nth-child(2) h1:first-of-type" do
      expect(page).to have_content "Combo set A2"
    end

    within ".deal:nth-child(3) h1:first-of-type" do
      expect(page).to have_content "Combo set A1 2"
    end

    within ".deal:nth-child(4) h1:first-of-type" do
      expect(page).to have_content "Combo set 2"
    end

  end

  scenario "order name asc" do
    visit combos_path
    click_link "Name"
    click_link "Name"

    within ".deal:nth-child(1) h1:first-of-type" do
      expect(page).to have_content "Combo bocom"
    end

    within ".deal:nth-child(2) h1:first-of-type" do
      expect(page).to have_content "Combo food 1"
    end

    within ".deal:nth-child(3) h1:first-of-type" do
      expect(page).to have_content "Combo hot 11"
    end

    within ".deal:nth-child(4) h1:first-of-type" do
      expect(page).to have_content "Combo set 1"
    end

  end

  scenario "load next page" do
    visit combos_path
    click_link "Next"

    expect(page).not_to have_content "Combo food 1"
    expect(page).not_to have_content "Combo bocom"
    expect(page).to have_content "Combo set B1"
    expect(page).to have_content "Combo set A2"

  end
end
