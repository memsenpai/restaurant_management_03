require "rails_helper"

RSpec.describe Table, type: :model do
  describe "associations" do
    it{should have_many :orders}
  end

  it ".find_table" do
    available_table = Table.find_table 50, Time.now + 10.days, 14, 10
    table = FactoryGirl.create :table
    expect(available_table).to_not include table
    expect(table.is_available?).to eq true
  end
end
