require "rails_helper"

RSpec.describe "orders/index", :type => :view do
  it "can show a form" do
    render
    expect(rendered).to have_selector "form"
  end
end
