require "rails_helper"

RSpec.describe MessageBroadcastJob, type: :job do
  dish = FactoryGirl.create :dish
  order = FactoryGirl.create :order
  order_dish = FactoryGirl.create :order_dish, order_id: order.id,
    dish_id: dish.id
  describe "method" do
    it{expect(MessageBroadcastJob.perform_now order_dish).to eq nil}
  end
end
