require 'rspec'
require 'soupcms/api'
require 'mongo'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

SoupCMSApi.configure do |config|
  config.data_resolver.register(/content$/, SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
end

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with 'rspec-mocks'

  config.include Helpers

  config.before(:suite) do
  end

  config.before(:each) do
    application = SoupCMS::Common::Model::Application.new('soupcms-test', 'soupCMS Test', 'http://localhost:9292/api/soupcms-test', 'http://localhost:9292/soupcms-test', 'mongodb://localhost:27017/soupcms-test')
    SoupCMS::Common::Strategy::Application::UrlBased.apps = {'soupcms-test' => application}

    db = Mongo::MongoClient.from_uri(application.mongo_uri).db
    db.collection_names.each do |collection_name|
      next if collection_name.match(/^system/)
      db.collection(collection_name).remove
    end
  end

  config.after(:suite) do
  end

end
