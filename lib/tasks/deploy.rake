require 'rake'

namespace :deploy do
  desc 'Setup once deployed'
  task :setup do
    setup
  end
  desc 'Deploy safely to Heroku'
  task :production do
    deploy(:production)
  end

  desc 'Deploy current branch to Staging on Heroku'
  task :staging do
    deploy(:staging)
  end

  def deploy(env)
    Bundler.with_clean_env do
      @production = (env == :production)
      @app_name =  @production ? "mercer-inpharmd" : "staging-mercer-inpharmd"
      run_deploy_cmd
      heroku "pg:backups capture"
      heroku "run rake db:migrate"
      heroku "run rake db:seed"
      heroku "run rake sync_plans_with_stripe"
      heroku "restart"
      sh "curl -o /dev/null http://#{@app_name}.herokuapp.com"
    end
  end

  def setup
    # runs on heroku
    [
      "db:setup",
      "sync_plans_with_stripe",
      "dev:prime"
    ].each { |id| Rake::Task[id].invoke }
  end

  ## Commands to finish if deploy succeeds (bumps version on production) but returns error
  ## ./heroku pg:backups capture && ./heroku run rake db:migrate && ./heroku run rake db:seed && ./heroku run rake sync_plans_with_stripe && ./heroku restart





  def run_deploy_cmd
    latest_tag = run_system_cmd 'git describe --tags $(git rev-list --tags --max-count=1)'
    deploy_cmd = "git push #{@production ? "production #{latest_tag}:master" : "-f staging HEAD:master"}"
    cmd = "#{deploy_cmd} || echo 'Exited with status 0: [#{deploy_cmd}] -- moving on.'" #Ignore exit status
    puts "Deploying to #{@production ? 'Production' : 'Staging'} with: #{deploy_cmd}"
    sh cmd
  end

  def heroku(cmd)
    sh "heroku #{cmd} --app #{@app_name}"
  end

  def run_system_cmd(cmd)
    `#{cmd}`.strip
  end

end
