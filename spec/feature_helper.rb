require 'rails_helper'
require 'capybara/rspec'
require 'capybara/angular'
require 'capybara/poltergeist'
require 'capybara/email/rspec'

def register_poltergeist_driver(options={})
  default_options = {
    :window_size  => [1280, 1440],
    :port => 44678+ENV['TEST_ENV_NUMBER'].to_i,
    :phantomjs_options => ['--proxy-type=none', '--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any'],
    :timeout => 120,
    # extensions: [ 'features/slocupport/angular_errors.js' ],
    js_errors: false,
    inspector: true
  }
  options = default_options.merge(options)
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, options)
  end
end
def register_chrome_driver
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end
register_poltergeist_driver
register_chrome_driver
Capybara.javascript_driver = :poltergeist
Capybara.save_and_open_page_path = 'tmp/'

RSpec.configure do |config|

  config.before(:suite) do
    MercerInpharmd::Application.load_tasks
    Rake::Task['assets:precompile'].invoke
  end

  config.before :all, type: :feature do
    DatabaseCleaner.strategy = :truncation, { except: config.seed_tables }
  end
  config.after :all, type: :feature do
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each, type: :feature) do |example|
    if example.metadata.key? :ignore_js_errors
      register_poltergeist_driver(js_errors: false)
      example.run
      register_poltergeist_driver
    else
      example.run
    end
  end

  config.around(:each) do |example|
    if example.metadata.key? :show_browser
      driver = Capybara.javascript_driver
      Capybara.javascript_driver = :selenium
      example.run
      Capybara.javascript_driver = driver
    else
      example.run
    end
  end

  config.before(:each, :js) do
    page.driver.block_unknown_urls if page.driver.respond_to?(:block_unknown_urls)
  end


  config.include SessionHelper::Features, type: :feature
  config.include ChosenHelper, type: :feature
  config.include Capybara::Angular::DSL, type: :feature

end
