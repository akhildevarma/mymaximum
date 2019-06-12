require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module MercerInpharmd
  class Application < Rails::Application
    if ENV['DEBUG']
      puts %Q(
        DEBUG::
          ENV['DEBUG'] #{ENV['DEBUG']}
          ENV['RAILS_ENV'] #{ENV['RAILS_ENV']}
          ENV['RAKE_ENV'] #{ENV['RAKE_ENV']}
          ENV['LOCAL'] #{ENV['LOCAL']}
        ===========
      )
    end
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif ie.css)

    config.active_job.queue_adapter = :delayed_job

    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      # g.test_framework :rspec, fixture: false
      g.factory_girl dir: '/spec/factories'
    end

    config.log_level = :debug

    # Paths
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')

    # Autoload
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/remote/**/**"]
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.after_initialize do
      Rails.application.routes.default_url_options = config.action_mailer.default_url_options
    end

  end
end
