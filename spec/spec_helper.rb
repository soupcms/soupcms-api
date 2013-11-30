require 'rspec'

require 'coveralls'
Coveralls.wear!

require 'soupcms/api'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with 'rspec-mocks'

  config.before(:suite) do
  end

  config.before(:each) do
    SoupCMS::Api::MongoDbConnection.new('soupcms-api-test').db.collection('posts').remove
  end

  config.after(:suite) do
  end

end
