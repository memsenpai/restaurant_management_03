require "rails_helper"

RSpec.describe Supports::AdminOrderSupport, type: :model do
  ad_order = Supports::AdminOrderSupport.new order: FactoryGirl.create(:order)
  it{expect(ad_order.load_data).to_not eq nil}
end
