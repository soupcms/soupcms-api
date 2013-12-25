require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMSApiRackApp.new
  end

  context 'search by tags' do

    before do
      BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => 1305000000, 'tags' => %w(tag1 tag2), 'title' => 'Title 1').create
      BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => 1306000000, 'tags' => %w(tag2 tag3), 'title' => 'Title 2').create
      BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => 1307000000, 'tags' => %w(tag4), 'title' => 'Title 3').create
    end

    it 'should return tag cloud with weight' do
      get URI.escape('/api/soupcms-test/posts/tag-cloud')

      tags = JSON.parse(last_response.body)
      expect(tags.size).to eq(4)
      expect(tags[0]['label']).to eq('tag1')
      expect(tags[0]['weight']).to eq(1)
      expect(tags[0]['link']['url']).to eq(URI.escape('/soupcms-test/posts?tags=tag1'))
      expect(tags[1]['label']).to eq('tag2')
      expect(tags[1]['weight']).to eq(2)
      expect(tags[2]['label']).to eq('tag3')
      expect(tags[2]['weight']).to eq(1)
      expect(tags[3]['label']).to eq('tag4')
      expect(tags[3]['weight']).to eq(1)
    end

  end

end