require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApiRackApp.new
  end

  context 'basic default' do

    context 'get published documents' do

      let(:env) { ENV['RACK_ENV'] }
      before do
        env
        ENV['RACK_ENV'] = 'production'

        20.times { BlogPostBuilder.new.with('state' => PUBLISHED).create }
        get '/api/soupcms-test/posts'
      end

      after do
        ENV['RACK_ENV'] = env
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(JSON.parse(last_response.body).length).to eq(10) }
      it { expect(last_response.headers['Cache-Control']).to eq('public, max-age=300') }
      it { expect(last_response.headers['Expires']).not_to be_nil }

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
        expect(docs[0]['url']).to eq('http://localhost:9292/soupcms-test/posts/first-post')
      end

      it 'should resolve reference dependency' do
        BlogPostBuilder.new.with('doc_id' => 'second_post','slug' => 'second-post', 'state' => PUBLISHED, 'title' => 'Title 2').create
        BlogPostBuilder.new.with('slug' => 'first-post', 'state' => PUBLISHED, 'title' => 'Title 1', 'another_post' => 'ref:posts:second_post').create
        get '/api/soupcms-test/posts/slug/first-post'
        doc = JSON.parse(last_response.body)
        expect(doc['another_post']['title']).to eq('Title 2')
      end
    end

    context 'fields' do
      before(:each) do
        BlogPostBuilder.new.with('slug' => 'first-post', 'state' => PUBLISHED, 'title' => 'Title 1', 'tags' => %w(tag1 tag2)).create
      end

      it 'should return only fields asked for from model' do
        get '/api/soupcms-test/posts/slug/first-post?fields[]=title&fields[]=slug'
        doc = JSON.parse(last_response.body)
        expect(doc['title']).to eq('Title 1')
        expect(doc['slug']).to eq('first-post')
        expect(doc['tags']).to be_nil
      end

      it 'should return all fields when not specified' do
        get '/api/soupcms-test/posts/slug/first-post'
        doc = JSON.parse(last_response.body)
        expect(doc['title']).to eq('Title 1')
        expect(doc['slug']).to eq('first-post')
        expect(doc['tags']).not_to be_nil
      end

    end



  end


end