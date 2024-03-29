# Rakefile
require 'prmd/rake_tasks/combine'
require 'prmd/rake_tasks/verify'
require 'prmd/rake_tasks/doc'

namespace :schema do
  Prmd::RakeTasks::Combine.new do |t|
    t.options[:meta] = 'schema/meta.json'    # use meta.yml if you prefer YAML format
    t.paths << 'schema/schemata/api'
    t.output_file = 'schema/api.json'
  end

  Prmd::RakeTasks::Verify.new do |t|
    t.files << 'schema/api.json'
  end

  Prmd::RakeTasks::Doc.new do |t|
    t.files = { 'schema/api.json' => 'schema/api.md' }
  end
end

task default: ['schema:combine', 'schema:verify', 'schema:doc']
