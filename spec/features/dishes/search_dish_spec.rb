require "rails_helper"

feature "Seach for food" do
  before :each do
    Dish.create!(name: "Food with apple", description: "About this food",
      image: "abc.jpg", price: 10, is_available: false)
    Dish.create!(name: "Apple in this food", description: "About this food",
      image: "abc.jpg", price: 11, is_available: true)
    Dish.create!(name: "Not have key word", description: "But this contain apple",
      image: "abc.jpg", price: 12, is_available: false)
    Dish.create!(name: "Sample food 4", description: "About this food",
      image: "abc.jpg", price: 13, is_available: true)
    Dish.create!(name: "Sample A food 5", description: "About this food",
      image: "abc.jpg", price: 14, is_available: false)
    Dish.create!(name: "Sample food 6", description: "About this food",
      image: "abc.jpg", price: 15, is_available: true)
    Dish.create!(name: "Sample food 7", description: "But this contain apple",
      image: "abc.jpg", price: 16, is_available: false)
    Dish.create!(name: "Sample food 8", description: "About this food",
      image: "abc.jpg", price: 17, is_available: true)
  end

  scenario "with right food name" do
    visit dishes_path
    fill_in :searchinput, with: "apple"
    click_button "Search"
    expect(page).to have_content "Food with apple"
    expect(page).to have_content "Apple in this food"
    expect(page).to have_content "Not have key word"
    expect(page).not_to have_content "Sample food 4"
  end

  scenario "with unavailable food name" do
    visit dishes_path
    fill_in :searchinput, with: "orange"
    click_button "Search"
    expect(page).to have_content "No entries found"
  end

end
