require "rails_helper"

RSpec.describe "layouts/application", :type => :view do
  it "have right view" do
    render file: "sessions/new.html.erb"
    expect(rendered).to have_content "Login (only for Staff) Email Password"
  end
end
