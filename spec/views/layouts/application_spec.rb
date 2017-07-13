require "rails_helper"

RSpec.describe "layouts/application", :type => :view do
  it "have right view" do
    render
    expect(rendered).to have_content "Awesomecity"
    expect(rendered).to have_content "Menu"
    expect(rendered).to have_content "Home"
    expect(rendered).to have_content "Booking"
    expect(rendered).to have_content "Combo"
    expect(rendered).to have_content "Check order"
    expect(rendered).to have_link href: "/cart"
  end

end
