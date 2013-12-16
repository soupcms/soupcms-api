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
    db = SoupCMS::Api::Model::Application.new('soupcms-test').connection.db
    db.collection_names.each do |collection_name|
      next if collection_name.match(/^system/)
      db.collection(collection_name).remove
    end
  end

  config.after(:suite) do
  end

end
