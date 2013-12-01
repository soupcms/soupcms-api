require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMS::ModelAPI
  end

  context 'search by tags' do

    before do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => 1305000000, 'tags' => %w(tag1 tag2), 'title' => 'Title 1').create
      BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => 1306000000, 'tags' => %w(tag2 tag3), 'title' => 'Title 2').create
      BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => 1307000000, 'tags' => %w(tag4), 'title' => 'Title 3').create
    end

    it 'should return documents matching a single tag' do
      get '/api/soupcms-api-test/posts?tags[]=tag1'

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(1)
      expect(docs[0]['title']).to eq('Title 1')
    end

    it 'should return documents matching multiple tags' do
      get '/api/soupcms-api-test/posts?tags[]=tag3&tags[]=tag4'

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(2)
      expect(docs[0]['title']).to eq('Title 3')
      expect(docs[1]['title']).to eq('Title 2')
    end

  end

end