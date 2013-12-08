require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'soupcms/api'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


task :seed do
  conn = SoupCMS::Api::MongoDbConnection.new('soupcms-test')
  db = conn.db
  # clean up database
  puts 'Cleaning up the database...'
  db.collection_names.each { |name|
      next if name.match(/^system/)
      db[name].remove
  }
  # import jsons
  Dir.glob('spec/seed/**/*.json').each do |file|
    puts "Importing file... #{file}"
    file =  File.new(file)
    model = file.path.split('/')[2]
    db[model].insert(JSON.parse(file.read))
  end
  conn.close
end
