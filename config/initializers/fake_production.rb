if ENV['FAKE_PRODUCTION']
  puts "FAKING PRODUCTION"
  Rails.application.config do |config|
    # Do not fallback to assets pipeline if a precompiled asset is missed.
    config.assets.compile = false
    config.assets.debug = false
    config.assets.compress = false
  end
end
