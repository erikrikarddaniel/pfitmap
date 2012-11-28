# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Add this to load Capybara integration
require 'capybara/rspec'
require 'capybara/rails'
include ActionDispatch::TestProcess

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Added because use of js switches the capybara driver and 
  # transactional fixtures only work with the default Rack::Test driver.

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
  
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  
  # Include my custom integration spec helper, intended to help out with 
  # omniauth authentication.
  config.include IntegrationSpecHelper
  config.include ControllerSpecHelper
end

Capybara.default_host = 'http://example.org'

# Run js-specs without launching firefox
Capybara.javascript_driver = :webkit

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:open_id] = 
  OmniAuth::AuthHash.new({
                           :provider => 'open_id',
                           :uid => '12345',
                           :info => {
                             :name => 'Bob Guest',
                             :email => 'bob@example.com'
                           },
                         })
