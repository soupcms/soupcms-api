require 'spec_helper'

describe 'Verify MongoDB Connection' do

  it 'should verify simple mongodb connection' do
    expect(SoupCMS::Api::MongoDbConnection.new('local').conn.database_names.size).to be > 0
  end


end