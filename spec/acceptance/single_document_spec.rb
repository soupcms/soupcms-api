require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApi
  end

  context 'search by doc_id' do
    it 'should return 404 when document not found' do
      get '/api/soupcms-api-test/posts/doc_id/1234'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('Document 1234 not found.')
    end

    it 'should get a document when search by doc_id' do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'Title 1', 'doc_id' => '1234').create

      get '/api/soupcms-api-test/posts/doc_id/1234'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['title']).to eq('Title 1')
    end

    it 'should not get draft document when search by doc_id' do
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Title 1', 'doc_id' => '1234').create

      get '/api/soupcms-api-test/posts/doc_id/1234'

      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('Document 1234 not found.')
    end

    it 'should not get draft document when search by doc_id' do
      BlogPostBuilder.new.with('state' => DRAFT, 'title' => 'Title 1', 'doc_id' => '1234', 'latest' => true).create

      get '/api/soupcms-api-test/posts/doc_id/1234?include=drafts'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['title']).to eq('Title 1')
    end

  end

  context 'search by slug' do

    it 'should return document matching slug' do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'Title 1', 'slug' => 'my-first-blog').create
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'Title 2', 'slug' => 'my-second-blog').create

      get '/api/soupcms-api-test/posts/slug/my-first-blog'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['title']).to eq('Title 1')
    end

  end



end