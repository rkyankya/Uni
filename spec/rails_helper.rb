# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RACK_ENV'] = ENV['RAILS_ENV'] ||= 'test'

# Enable coverage checking when requested.
if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start('rails')
end

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'webmock/rspec'

# Disable all net connections except ones to localhost, and to locations the webdrivers gem downloads its binaries from.
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [
    %r{github.com/mozilla/geckodriver/releases},
    /github-production-release-asset/,
    'chromedriver.storage.googleapis.com'
  ]
)

# Let's spec emails.
require 'capybara/email/rspec'

# Let's spec policies.
require 'pundit/rspec'

# Load all web-drivers.
require 'webdrivers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = ::Rails.root.join('spec/fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Set type to :service for all service_spec-s.
  config.define_derived_metadata(file_path: Regexp.new('/spec/services/')) do |metadata|
    metadata[:type] = :service
  end

  # Include email helpers in service and job specs.
  config.include Capybara::Email::DSL, type: :service
  config.include Capybara::Email::DSL, type: :job

  # Include Factory Girl's helpers.
  config.include FactoryBot::Syntax::Methods

  # Devise includes some test helpers for functional specs.
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Allow using broken flag to exclude tests
  config.filter_run_excluding broken: true

  # Remember failures. Run only failed tests with the --only-failures flag.
  config.example_status_persistence_file_path = "examples.txt"

  config.before(:each, js: true) do
    Capybara.page.driver.browser.manage.window.maximize unless Capybara.javascript_driver == :cuprite
  end

  include AnObjectLikeMatcher
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1920,1080")
  options.headless!

  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :headless_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.headless!

  Capybara::Selenium::Driver.new app, browser: :firefox, options: options
end

if ENV['JAVASCRIPT_DRIVER'] == 'cuprite'
  require "capybara/cuprite"
end

Capybara.javascript_driver = ENV['JAVASCRIPT_DRIVER'].present? ? ENV['JAVASCRIPT_DRIVER'].to_sym : :headless_chrome

# Use rspec-retry to retry pesky intermittent failures.
require 'rspec/retry'

RSpec.configure do |config|
  # Show retry status in spec process.
  config.verbose_retry = true

  # Try twice (retry once).
  config.default_retry_count = 2

  # Only retry when Selenium raises Net::ReadTimeout.
  config.exceptions_to_retry = [Net::ReadTimeout]
end

# Increase Capybara's default maximum wait time to 5 seconds to allow for some slow responds (timeline builder).
Capybara.default_max_wait_time = ENV['CAPYBARA_MAX_WAIT_TIME'].present? ? ENV['CAPYBARA_MAX_WAIT_TIME'].to_i : 5

# Save screenshots on failure (and more).
require 'capybara-screenshot/rspec'
Capybara::Screenshot.prune_strategy = { keep: 20 }

%i[chrome headless_chrome firefox headless_firefox].each do |driver_name|
  Capybara::Screenshot.register_driver(driver_name) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end

Capybara::Screenshot.register_driver(:cuprite) do |driver, path|
  driver.browser.render(path)
end

# Faker should use India as locale.
Faker::Config.locale = 'en-IND'