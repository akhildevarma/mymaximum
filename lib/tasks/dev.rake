namespace :dev do
  desc 'Seeds for development'
  task :prime do
    prime if (ENV['DATA_ENV'] == 'staging' || Rails.env.development? || Rails.env.testing?)
  end


  def prime
    Rake::Task["db:seed_fu"].invoke
  end

end
