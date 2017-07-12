require "rails_helper"

RSpec.describe "pages/home", :type => :view do
  before(:each) do
    @dish = Dish.create(id: 1,
      name: "Food name", description: "About this food", image: "food.jpg")
    @dishes = Array.new(5, @dish)
    @combo = Combo.create(id: 2, name: "Combo name",
      description: "About this combo",
      image: "combo.jpg", discount: 10)
    @combos = Array.new(3, @combo)
  end

  it "have right view" do
    render
    expect(rendered).to have_content "Awesomecity"
    expect(rendered).to have_content "Food name"
    expect(rendered).to have_content "Combo name"
    expect(rendered).to have_link "View menu", href: dishes_path
    expect(rendered).to have_link "Book table", href: tables_path
  end

end
