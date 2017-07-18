class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform arg
    ActionCable.server.broadcast "messages", arg
  end
end
