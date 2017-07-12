require "rails_helper"

RSpec.describe Supports::AdminOrder, type: :model do
  ad_order = Supports::AdminOrder.new order: FactoryGirl.create(:order)
  it{expect(ad_order.load_data).to_not eq nil}
end
