def interesting_tables
  rval = ActiveRecord::Base.connection.tables.sort
  rval.reject! do |tbl|
    ['schema_migrations','schema_info', 'sessions', 'public_exceptions'].include?(tbl)
  end
  rval
end

namespace :db do
  namespace :backup do


    desc "Reload the database and rerun migrations"
    task :redo do
      Rake::Task['db:backup:write'].invoke
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:backup:read'].invoke
    end

    desc "Dump entire db."
    task :write => :environment do

      dir = Rails.root.join('db/backup')
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
      interesting_tables.each do |tbl|
        begin
          klass = tbl.classify.constantize
          puts "Writing #{tbl}..."
          File.open("#{tbl}.yml", 'wb+') { |f| YAML.dump klass.all.collect(&:attributes), f }
        rescue
          puts "::Error:: Failed to load table #{tbl}"
        end
      end
      FileUtils.chdir(Rails.root)
    end

    desc "Loads the entire db."
    task :read => [:environment, 'db:schema:load'] do

      dir = Rails.root.join('db/backup')
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)

      interesting_tables.each do |tbl|

        ActiveRecord::Base.transaction do

          begin
            klass = tbl.classify.constantize
            klass.destroy_all
            klass.reset_column_information

            YAML.load_file("#{tbl}.yml").each do |fixture|
              data = {}
              klass.columns.each do |c|
                # filter out missing columns
                data[c.name] = fixture[c.name] if fixture[c.name]
              end
              ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{data.keys.map{|kk| "#{kk}"}.join(",")}) VALUES (#{data.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
            end
            puts "#{klass.count} records loaded into #{tbl}."
          rescue
            puts "::Error:: Failed to load table #{tbl}"
          end
        end
      end

    end

  end
end
