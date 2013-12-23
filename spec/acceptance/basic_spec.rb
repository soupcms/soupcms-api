require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApi
  end

  context 'basic default' do

    context 'get published documents' do
      before do
        20.times { BlogPostBuilder.new.with('state' => PUBLISHED).create }
        get '/api/soupcms-test/posts'
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(JSON.parse(last_response.body).length).to eq(10) }
      #it { expect(last_response.headers['Cache-Control']).to eq('public, max-age=300') }
      #it { expect(last_response.headers['Expires']).not_to be_nil }

    end

    context 'no documents found' do
      before do
        get '/api/soupcms-test/posts'
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(JSON.parse(last_response.body).length).to eq(0) }
    end

    context 'draft request' do
      it 'include draft documents' do
        BlogPostBuilder.new.with('create_datetime' => 1305000000, 'state' => PUBLISHED, 'title' => 'Title 1', 'latest' => true).create
        BlogPostBuilder.new.with('create_datetime' => 1302000000, 'state' => DRAFT, 'title' => 'Title 2', 'latest' => true).create
        BlogPostBuilder.new.with('create_datetime' => 1301000000, 'state' => SCHEDULED, 'title' => 'Title 3', 'latest' => true).create

        get '/api/soupcms-test/posts?include=drafts'

        docs = JSON.parse(last_response.body)
        expect(docs.length).to eq(3)
        expect(docs[0]['title']).to eq('Title 1')
        expect(docs[1]['title']).to eq('Title 2')
        expect(docs[2]['title']).to eq('Title 3')
      end

      it 'should not set caching headers' do
        BlogPostBuilder.new.with('create_datetime' => 1302000000, 'state' => DRAFT, 'title' => 'Title 2', 'latest' => true).create

        get '/api/soupcms-test/posts?include=drafts'

        docs = JSON.parse(last_response.body)
        expect(docs.length).to eq(1)
        expect(last_response.headers['Cache-Control']).to be_nil
        expect(last_response.headers['Expires']).to be_nil
      end

    end

    context 'resolvers' do
      it 'should add url to the post object' do
        BlogPostBuilder.new.with('slug' => 'first-post', 'state' => PUBLISHED).create
        get '/api/soupcms-test/posts'
        docs = JSON.parse(last_response.body)
        expect(docs[0]['url']).to eq('/soupcms-test/posts/first-post')
      end

      it 'should resolve reference dependency' do
        BlogPostBuilder.new.with('slug' => 'second-post', 'state' => PUBLISHED, 'title' => 'Title 2').create
        BlogPostBuilder.new.with('slug' => 'first-post', 'state' => PUBLISHED, 'title' => 'Title 1', 'another_post_ref' => { 'model' => 'posts', 'match' => {'slug' => 'second-post'}}).create
        get '/api/soupcms-test/posts/slug/first-post'
        doc = JSON.parse(last_response.body)
        expect(doc['another_post_ref']['title']).to eq('Title 2')
      end
    end



  end


end