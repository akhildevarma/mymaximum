ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'shoulda/matchers'
require 'webmock/rspec'
require 'vcr'
require 'database_cleaner'

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
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Delayed::Worker.delay_jobs = false
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job_test.log'))

Dotenv.load

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }
  config.ignore_localhost = true
  config.ignore_hosts 'js.stripe.com'
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Add API Specs
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/

  config.add_setting(:seed_tables)
  config.seed_tables = %w(plans products)

  # All tests combined into suite
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation, except: config.seed_tables
    Rails.application.load_seed
  end
  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # All examples in group
  config.before(:all) do
    # DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation, except: config.seed_tables
  end

  # Each example in group
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = :truncation, { except: config.seed_tables }
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation, { except: config.seed_tables }
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    # Force the driver to wait till the page finishes loading
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end

  # Allow net connections
  config.around(:each) do |example|
    if example.metadata.key? :allow_net_connections
      WebMock.allow_net_connect!
      VCR.turned_off(ignore_cassettes: true) { example.run }
      WebMock.disable_net_connect!
    else
      example.run
    end
  end

  config.around(:each) do |example|
    if example.metadata.key? :delayed_job
      # Active job test adapter; for use with `RSpec::Rails::Matchers::ActiveJob`.
      original_adapter = ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter = :test
      # Delay jobs; similar to as in production.
      delay_setting = Delayed::Worker.delay_jobs
      Delayed::Worker.delay_jobs = true
      # Run example with above settings.
      example.run
      # Reset original settings.
      ActiveJob::Base.queue_adapter = original_adapter
      Delayed::Worker.delay_jobs = delay_setting
    else
      example.run
    end
  end

  # Speak after suite completes
  config.after(:suite) do
    examples = RSpec.world.filtered_examples.values.flatten
    word = if examples.none?(&:exception)
      'Pass!'
           else
      'Complete.'
    end
    RspecGods.summon('Victoria').to_say(word)
  end

  # Only include SQL in :db tests
  ActiveRecord::Base.logger = nil

  def with_std_out_logger
    default_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    yield
  ensure
    ActiveRecord::Base.logger = default_logger
  end

  config.around(:each, db: true) do |example|
    with_std_out_logger { example.run }
  end

  # Allow stubbing of controller helpers in view spec
  config.around(:each, type: :view) do |ex|
    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = false
      ex.run
      mocks.verify_partial_doubles = true
    end
  end

  config.around(:each) do |example|
    Timeout::timeout(140) { example.run }
  end

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

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # Spec Helpers
  config.include Requests::JsonHelpers, type: :request
  config.include SessionHelper::Controllers, type: :controller
  config.include SessionHelper::Requests, type: :request

  config.include FactoryGirl::Syntax::Methods

end
