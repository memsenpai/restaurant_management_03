require "rails_helper"

feature "booking" do
  scenario "with full invalid info" do
    visit orders_path

    fill_in "order_email", with: "mailfake@example.com"
    fill_in "order_code", with: "codefake"

    click_button "Submit"

    expect(page).to have_content "Can't find any order with this infomation!"
  end

  scenario "with full valid info" do
    visit orders_path

    fill_in "order_email", with: "mail@example.com"
    fill_in "order_code", with: "asd01"
    click_button "Submit"

    visit cart_path

    expect(page).not_to have_content "Order code: asd01"
  end

  scenario "without email" do
    visit orders_path

    fill_in "order_code", with: "codefake"
    click_button "Submit"

    expect(page).to have_content "Can't find any order with this infomation!"
  end

  scenario "without code" do
    visit orders_path

    fill_in "order_email", with: "mail@example.com"
    click_button "Submit"

    expect(page).to have_content "Can't find any order with this infomation!"
  end

end
