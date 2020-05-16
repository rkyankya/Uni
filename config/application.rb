require_relative 'boot'
require 'rails/all'

if Rails.env.development?
  require 'dotenv'
  Dotenv.load
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Svapp
  class Application < Rails::Application
    # Configure the path for configuration classes that should be used before initialization
    # NOTE: path should be relative to the project root (Rails.root)
    # config.anyway_config.autoload_static_config_path = "config/configs"
    #
    # Initialize configuration defaults for originally generated Rails version.
    #
    # Note: This is not the original Rails version. However, this is the easiest way to enforce the latest defaults.
    config.load_defaults 6.0

    config.assets.precompile << 'delayed/web/application.css'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Nairobi'

    config.i18n.enforce_available_locales = true

    # include nested directories inside locale
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml')]

    Dir.glob('config/routes/*.rb').each do |file|
      config.paths['config/routes.rb'] << Rails.root.join(file)
    end

    config.action_mailer.delivery_method = :postmark

    config.action_mailer.postmark_settings = { api_token: Rails.application.credentials.postmark_api_token }

    # Precompile fonts.
    config.assets.paths << Rails.root.join('app/assets/fonts')

    # Add some paths to autoload
    %w[presenters services forms/concerns].each do |folder|
      config.autoload_paths.push(Rails.root.join('app', folder))
    end
  end
end
