web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rake jobs:work NEW_RELIC_DISPATCHER=delayed_job
release: rake db:migrate
