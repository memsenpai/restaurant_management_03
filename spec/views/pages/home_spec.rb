require "rails_helper"

RSpec.describe "pages/home", :type => :view do
  before(:each) do
    @dish = Dish.create!(name: "Food with apple", description: "About this food",
      image: "google.com", price: 1, is_available: false)
    @dishes = Array.new(5, @dish)
    @combo = Combo.create(name: "Combo name",
      description: "About this combo",
      image: "combo.jpg", discount: 10)
    @combos = Array.new(3, @combo)
  end

  it "have right view" do
    render
    expect(rendered).to have_content "Awesomecity"
    expect(rendered).to have_content "Great food"
    expect(rendered).to have_content "Tastes good"
    expect(rendered).to have_link "View menu", href: dishes_path
    expect(rendered).to have_link "Book table", href: tables_path
  end

end
