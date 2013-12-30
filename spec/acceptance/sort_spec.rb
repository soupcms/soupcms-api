require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApiRackApp.new
  end

  context 'sort' do

    it 'should returns documents sorted by title ascending' do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'B Title 1', 'latest' => true).create
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Z Title 2', 'latest' => true).create
      BlogPostBuilder.new.with('state' => SCHEDULED, 'title' => 'C Title 3', 'latest' => true).create

      get '/api/soupcms-test/posts?include=drafts&sort[]=title&sort_order=descending'

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(3)
      expect(docs[0]['title']).to eq('B Title 1')
      expect(docs[1]['title']).to eq('C Title 3')
      expect(docs[2]['title']).to eq('Z Title 2')
    end

    it 'should returns documents sorted by title descending' do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'B Title 1', 'latest' => true).create
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Z Title 2', 'latest' => true).create
      BlogPostBuilder.new.with('state' => SCHEDULED, 'title' => 'C Title 3', 'latest' => true).create

      get '/api/soupcms-test/posts?include=drafts&sort[]=-title&sort_order=descending'

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(3)
      expect(docs[2]['title']).to eq('B Title 1')
      expect(docs[1]['title']).to eq('C Title 3')
      expect(docs[0]['title']).to eq('Z Title 2')
    end

  end


end