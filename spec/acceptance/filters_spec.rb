require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApi
  end

  context 'search by title' do

    before do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'My first blog post', 'category' => 'cooking', 'rank' => 25).create
      BlogPostBuilder.new.with('state' => PUBLISHED, 'title' => 'My second blog post', 'category' => 'technical', 'rank' => 30).create
    end

    it 'should exactly match' do
      get URI.escape('/api/soupcms-test/posts?filters=title&title="My first blog post"')

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(1)
      expect(docs[0]['title']).to eq('My first blog post')
    end

    it 'should match with give regular expression' do
      get URI.escape('/api/soupcms-test/posts?filters=title&title=/post/')

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(2)
      expect(docs[0]['title']).to eq('My first blog post')
      expect(docs[1]['title']).to eq('My second blog post')
    end

    it 'should match multiple filters' do
      get URI.escape('/api/soupcms-test/posts?filters[]=title&filters[]=category&title=/post/&category="cooking"')

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(1)
      expect(docs[0]['title']).to eq('My first blog post')
    end

    it 'should match filter with multiple value as or condition' do
      get URI.escape('/api/soupcms-test/posts?filters[]=title&filters[]=category&title=/post/&category[]="cooking"&category[]="technical"')

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(2)
      expect(docs[0]['title']).to eq('My first blog post')
      expect(docs[1]['title']).to eq('My second blog post')
    end

    it 'should match filter with integer value' do
      get URI.escape('/api/soupcms-test/posts?filters=rank&rank=25')

      docs = JSON.parse(last_response.body)
      expect(docs.length).to eq(1)
      expect(docs[0]['title']).to eq('My first blog post')
    end

  end

end