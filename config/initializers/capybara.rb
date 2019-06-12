if Rails.env.test?
  Capybara.default_wait_time = 30 # seconds
end
