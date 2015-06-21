require 'rspec'
require 'soupcms/api'
require 'mongo'

Mongo::Logger.logger.level = Logger::INFO

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

SoupCMSApi.configure do |config|
  config.data_resolver.register(/content$/, SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
end

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec

  config.include Helpers

  config.before(:suite) do
  end

  config.before(:each) do
    application = SoupCMS::Common::Model::Application.new('soupcms-test', 'soupCMS Test', 'http://localhost:9292/api/soupcms-test', 'http://localhost:9292/soupcms-test', 'mongodb://127.0.0.1:27017/soupcms-test')
    SoupCMS::Common::Strategy::Application::UrlBased.apps = {'soupcms-test' => application}

    MongoDatabase.clean(application.mongo_uri)
  end

  config.after(:suite) do
  end

end

class MongoDatabase

  def self.clean(mongo_uri)
    @@db ||= Mongo::Client.new(mongo_uri).database
    @@db.collections.each do |collection|
      next if collection.name.match(/^system/)
      collection.drop
    end      
  end  

end  
