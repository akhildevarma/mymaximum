# ./spec/tasks/top_users_spec.rb

require 'rails_helper'
require 'rake'

describe 'admin_info namespace rake task' do
  before :all do
    Rake.application.rake_require 'tasks/admin_info'
    Rake::Task.define_task(:environment)
  end

  describe 'admin_info:top_users' do
    let :run_rake_task do
      name = 'admin_info:top_users'
      Rake::Task[name].reenable
      Rake.application.invoke_task name
    end

    it 'works' do
      expect { run_rake_task }.not_to raise_exception
    end
  end
end
