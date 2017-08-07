class OrderBroadcastJob < ApplicationJob
  queue_as :default

  def perform arg
    ActionCable.server.broadcast "orders", arg
  end
end
