require "rails_helper"

feature "filter food" do
  before :each do
    Dish.create!(name: "Food with apple", description: "About this food",
      image: "google.com", price: 1, is_available: false)
    Dish.create!(name: "Apple in this food", description: "About this food",
      image: "google.com", price: 5, is_available: true)
    Dish.create!(name: "Not have key word", description: "But this contain
      apple",  image: "google.com", price: 12, is_available: false)
    Dish.create!(name: "Sample food 4", description: "About this food",
      image: "google.com", price: 60, is_available: true)
    Dish.create!(name: "Sample A food 5", description: "About this food",
      image: "google.com", price: 70, is_available: false)
    Dish.create!(name: "Sample food 6", description: "About this food",
      image: "google.com", price: 80, is_available: true)
    Dish.create!(name: "Sample food 7", description: "But this contain apple",
      image: "google.com", price: 90, is_available: false)
    Dish.create!(name: "Sample food 8", description: "About this food",
      image: "google.com", price: 100, is_available: true)
  end

  scenario "order price desc" do
    visit dishes_path
    click_link "Price"

    within ".items:nth-child(1) h4:first-of-type" do
      expect(page).to have_content "Sample food 8"
    end

    within ".items:nth-child(2) h4:first-of-type" do
      expect(page).to have_content "Sample food 7"
    end

    within ".items:nth-child(3) h4:first-of-type" do
      expect(page).to have_content "Sample food 6"
    end

    within ".items:nth-child(4) h4:first-of-type" do
      expect(page).to have_content "Sample A food 5"
    end

  end

  scenario "order price asc" do
    visit dishes_path
    click_link "Price"
    click_link "Price"

    within ".items:nth-child(1) h4:first-of-type" do
      expect(page).to have_content "Food with apple"
    end

    within ".items:nth-child(2) h4:first-of-type" do
      expect(page).to have_content "Apple in this food"
    end

    within ".items:nth-child(3) h4:first-of-type" do
      expect(page).to have_content "Not have key word"
    end

    within ".items:nth-child(4) h4:first-of-type" do
      expect(page).to have_content "Sample food 4"
    end

  end

  scenario "order name desc" do
    visit dishes_path
    click_link "Name"

    within ".items:nth-child(1) h4:first-of-type" do
      expect(page).to have_content "Sample food 8"
    end

    within ".items:nth-child(2) h4:first-of-type" do
      expect(page).to have_content "Sample food 7"
    end

    within ".items:nth-child(3) h4:first-of-type" do
      expect(page).to have_content "Sample food 6"
    end

    within ".items:nth-child(4) h4:first-of-type" do
      expect(page).to have_content "Sample food 4"
    end

  end

  scenario "order name asc" do
    visit dishes_path
    click_link "Name"
    click_link "Name"

    within ".items:nth-child(1) h4:first-of-type" do
      expect(page).to have_content "Apple in this food"
    end

    within ".items:nth-child(2) h4:first-of-type" do
      expect(page).to have_content "Food with apple"
    end

    within ".items:nth-child(3) h4:first-of-type" do
      expect(page).to have_content "Not have key word"
    end

    within ".items:nth-child(4) h4:first-of-type" do
      expect(page).to have_content "Sample A food 5"
    end

  end

  scenario "load next page" do
    visit dishes_path
    click_link "Next"

    expect(page).not_to have_content "Food with apple"
    expect(page).not_to have_content "Apple in this food"
    expect(page).not_to have_content "Not have key word"
    expect(page).not_to have_content "Sample food 4"
    expect(page).not_to have_content "Sample A food 5"
    expect(page).not_to have_content "Sample food 6"
    expect(page).to have_content "Sample food 7"
    expect(page).to have_content "Sample food 8"

  end

  # haven't code yet
  # scenario "change status Available" do
  #   visit dishes_path
  #   find("#q_is_available_true").select("Available")
  #
  #   expect(page).not_to have_content("Food with apple")
  #   expect(page).not_to have_content("Not have key word")
  #   expect(page).not_to have_content("Sample food 4")
  #   expect(page).not_to have_content("Sample A food 5")
  #   expect(page).to have_content("Apple in this food")
  #   expect(page).to have_content("Sample food 4")
  #   expect(page).to have_content("Sample food 6")
  #   expect(page).to have_content("Sample food 8")
  #
  # end
end
