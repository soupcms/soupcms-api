require 'rspec'
require 'soupcms/api'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with 'rspec-mocks'

  config.before(:suite) do
  end

  config.before(:each) do
    application = SoupCMS::Api::Model::Application.new('soupcms-test')
    SoupCMS::Api::MongoDbConnection.new(application).db.collection('posts').remove
  end

  config.after(:suite) do
  end

end
