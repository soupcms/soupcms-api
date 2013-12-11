require 'spec_helper'

describe 'Verify MongoDB Connection' do

  it 'should verify simple mongodb connection' do
    application = SoupCMS::Api::Model::Application.new('local')
    expect(SoupCMS::Api::MongoDbConnection.new(application).conn.database_names.size).to be > 1
  end


end