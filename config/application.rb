require_relative "boot"

require "csv"
require "rails/all"

Bundler.require(*Rails.groups)

module Restaurant
  class Application < Rails::Application
    config.time_zone = "Hanoi"
    config.active_record.default_timezone = :local
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
