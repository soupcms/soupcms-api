require 'rspec'
require 'soupcms/api'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

SoupCMSApi.configure do |config|
  config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
end

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with 'rspec-mocks'

  config.before(:suite) do
  end

  config.before(:each) do
    application = SoupCMS::Api::Model::Application.new('soupcms-test', 'http://localhost:9292/soupcms-test')
    SoupCMS::Api::Strategy::Application::UrlBased.apps = { 'soupcms-test' => application}

    db = Mongo::MongoClient.from_uri(application.mongo_uri).db
    db.collection_names.each do |collection_name|
      next if collection_name.match(/^system/)
      db.collection(collection_name).remove
    end
  end

  config.after(:suite) do
  end

end
