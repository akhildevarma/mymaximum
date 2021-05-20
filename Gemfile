source 'https://rubygems.org'
ruby '2.2.5'

# Core Systems Gems
gem 'rails', '4.2.0'
gem 'rake', '10.5.0'
gem 'pg', '~> 0.18.1'

# Server Configuration Gems
gem 'foreman', '~> 0.61.0'
gem 'unicorn', '~> 4.6.3'
gem 'responders', '~> 2.0'

# Stylesheet Gems
gem 'sass-rails', '~> 5.0.0'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'font-awesome-sass', '~> 4.3.0'

# Javascript Gems
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails', '~> 4.0'

# HTML/JSON Gems
gem 'slim-rails'
gem 'simple_form', '~> 3.1.0'
gem 'active_model_serializers', '~> 0.10.0'
gem 'draper', '~> 1.3.1'
gem 'mustache', '~> 0.99.4'
gem 'rabl', '~> 0.11.6'
gem 'high_voltage', '~> 1.2.4'

# Background Worker Gems
gem 'delayed_job', '~> 4.0.5'
gem 'delayed_job_active_record', '~> 4.0.1'
gem 'delayed_job_web', '~> 1.2.5'

# Workflow Gems
gem 'bcrypt', '~> 3.1.1'
gem 'enumerize', '~> 0.6.1' # handy enumerated type gem
gem 'workflow', '~> 1.2.0' # finite state machine DSL
gem 'nokogiri', '~> 1.9.1'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'validates_email_format_of', '~> 1.5.3'

gem 'httparty', '~> 0.10.2'
gem 'httmultiparty', '~> 0.3.10' # multipart uploads
gem 'mechanize', '~> 2.7.2' # headless web browser: for when HTTParty isn't enough
gem 'sanitize', '~> 2.0.4' # html sanitizer

# 3rd Party Tools
gem 'twilio-ruby', '~> 3.10.1'
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'newrelic_rpm', '~> 3.12.1.298'

# Grape API
gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails', '~> 0.2.1'
# gem 'grape-swagger-ui'
gem 'grape-entity'
gem 'rack-contrib'
gem 'hashie-forbidden_attributes'
gem 'grape-jsonapi-resources'
gem 'roar'
gem 'grape-roar'
gem "grape-active_model_serializers", git: "https://github.com/jrhe/grape-active_model_serializers.git"


# API Blueprint
gem 'dredd-rack', '~> 0.4.0' # see semver.org

# JSON Schema Validation
gem 'json-schema'
gem 'prmd'

# Local Time
gem 'local_time'

gem 'active_model-errors_details'

# API
gem 'jsonapi-resources'

# Pagination
gem 'will_paginate', '~> 3.0.6'

# Active Record import for large inserts to db
gem 'activerecord-import', '~> 0.2.0'

# .csv/.xls/.xlsx parser
gem 'roo', '~> 2.1.0'

#track changes to your models, for auditing or versioning
gem 'paper_trail'
gem 'closure_tree'

# Mail sender to replace Mandrill
gem 'postmark-rails'

# inline edit
gem 'best_in_place'

# Dashboard charts
gem 'chartkick'

# Admin
gem "administrate", "~> 0.2.2"
gem 'bourbon'

gem "non-stupid-digest-assets"

gem 'paperclip'
gem 'aws-sdk', '~> 2.3'
gem 'browser'

gem 'has_secure_token'

gem 'gibbon'

group :development do
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'guard-bundler'
  # gem 'guard-rspec'
  gem 'guard-rubocop'

  gem 'letter_opener_web', '~> 1.2.0'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug', '~> 3.3.0'
  gem 'pry', '~> 0.10.1'
  gem 'pry-remote', '~> 0.1.8'
  gem 'pry-nav'
  gem 'pry-stack_explorer', '~> 0.4.9.2'
  gem 'sourcify'
  gem 'rubocop', '~> 0.29.1', require: false
  gem 'rspec-rails', '~> 3.4.1'
  gem 'rspec-its', '~> 1.2.0'
  gem 'rspec-collection_matchers'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', '~> 2.8.0', require: false
  gem 'spring', '~> 1.3.6'

  gem 'dotenv-rails'

  gem 'rspec-retry'
  gem 'rspec-instafail'
  gem 'parallel_tests'
  gem 'teaspoon'#, :git => 'https://github.com/jejacks0n/teaspoon.git', :branch => '2-3-stable'
  gem "teaspoon-jasmine"
  gem 'sprockets-rails', '~> 2.0'
end

group :development, :production do
  gem 'seed-fu', '~> 2.3'
end

group :development, :test, :production do
  gem 'factory_girl'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.4.3'
  gem 'forgery'
end

group :test do
  gem 'capybara', '~> 2.4.4', require: false
  gem 'capybara-angular', require: false
  gem 'capybara-email', require: false
  gem 'capybara-slow_finder_errors', require: false
  gem 'codecov', github: 'codecov/codecov-ruby', branch: 'master', require: false
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'

  gem 'launchy' # save_and_open_page
  gem 'vcr', '~> 2.9.3'
  gem 'poltergeist', require: false
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'selenium-webdriver'
  gem 'rack_session_access'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end
