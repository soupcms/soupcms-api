require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApiRackApp.new
  end

  context 'sort' do

    it 'should returns documents sorted by specified field' do
      BlogPostBuilder.new.with({'doc_id' => 1234, 'locale' => 'en_GB', 'latest' => true, 'version' => 1}).create
      BlogPostBuilder.new.with({'doc_id' => 1234, 'locale' => 'en_US', 'latest' => true, 'version' => 2}).create

      get '/api/soupcms-test/posts?include=drafts&locale=en_GB'

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(1)
      expect(docs[0]['locale']).to eq('en_GB')
    end

  end


end