require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMS::ModelAPI
  end

  context 'basic default' do

    context 'get published documents' do
      before do
        20.times { BlogPostBuilder.new.with('state' => PUBLISHED).create }
        get '/api/soupcms-api-test/posts'
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(JSON.parse(last_response.body).length).to eq(10) }
    end

    context 'no documents found' do
      before do
        get '/api/soupcms-api-test/posts'
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(JSON.parse(last_response.body).length).to eq(0) }
    end

    it 'should get all draft documents' do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'Title 1', 'latest' => true).create
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Title 2', 'latest' => true).create
      BlogPostBuilder.new.with('state' => SCHEDULED, 'title' => 'Title 3', 'latest' => true).create

      get '/api/soupcms-api-test/posts?include=drafts'

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(3)
      expect(docs[0]['title']).to eq('Title 1')
      expect(docs[1]['title']).to eq('Title 2')
      expect(docs[2]['title']).to eq('Title 3')
    end

  end


end