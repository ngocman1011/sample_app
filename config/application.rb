require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    config.i18n.available_locales = [:en, :vi]

    config.i18n.default_locale = :vi

    config.active_record.default_timezone = :local

    config.time_zone = "Hanoi"

    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
