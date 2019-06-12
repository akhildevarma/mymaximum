namespace :local_data do
  require 'dotenv/tasks' if Rails.env.development?
  desc 'Sync local database with production database'
  namespace :sync do
    task :production, [:restore_only] => :dotenv do |t, args|
      args.with_defaults(:restore_only => false)
      app_name = "mercer-inpharmd"
      filename = 'production.dump'
      path = Rails.root.join("test/#{filename}")
      db_config = Rails.application.config.database_configuration[Rails.env]


      Bundler.with_clean_env do
        host = db_config["host"]
        user = db_config["user"]
        db_name = db_config["database"]
        if args[:restore_only] == false
          sh "heroku pg:backups capture --app #{app_name}"
          sh "curl -o #{path} --create-dirs `heroku pg:backups public-url --app #{app_name}`"
        end
        sh "pg_restore --verbose --clean --no-acl --no-owner -h #{host} -U #{user} -d #{db_name} #{path} || true"
      end
    end


  end
end
