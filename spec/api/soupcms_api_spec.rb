require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMS::ModelAPI
  end

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

  context 'get published document matching tags' do

    before do
      BlogPostBuilder.new.with('state' => PUBLISHED,'publish_datetime' => 1305000000, 'tags' => %w(tag1 tag2), 'title' => 'Title 1').create
      BlogPostBuilder.new.with('state' => PUBLISHED,'publish_datetime' => 1306000000, 'tags' => %w(tag2 tag3), 'title' => 'Title 2').create
      BlogPostBuilder.new.with('state' => PUBLISHED,'publish_datetime' => 1307000000, 'tags' => %w(tag4), 'title' => 'Title 3').create
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

  it 'should get all draft documents' do
    BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'Title 1','latest' => true).create
    BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Title 2','latest' => true).create
    BlogPostBuilder.new.with('state' => SCHEDULED, 'title' => 'Title 3','latest' => true).create

    get '/api/soupcms-api-test/posts?include=drafts'

    docs = JSON.parse(last_response.body)
    expect(docs.length).to eq(3)
    expect(docs[0]['title']).to eq('Title 1')
    expect(docs[1]['title']).to eq('Title 2')
    expect(docs[2]['title']).to eq('Title 3')
  end

  context 'request with doc_id' do
    it 'should return 404 when document not found' do
      get '/api/soupcms-api-test/posts/1234'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('Document 1234 not found.')
    end

    it 'should get a document when search by doc_id' do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'Title 1','doc_id' => '1234').create

      get '/api/soupcms-api-test/posts/1234'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['title']).to eq('Title 1')
    end

    it 'should not get draft document when search by doc_id' do
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Title 1','doc_id' => '1234').create

      get '/api/soupcms-api-test/posts/1234'

      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('Document 1234 not found.')
    end

    it 'should not get draft document when search by doc_id' do
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Title 1','doc_id' => '1234', 'latest' => true).create

      get '/api/soupcms-api-test/posts/1234?include=drafts'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['title']).to eq('Title 1')
    end

  end


end