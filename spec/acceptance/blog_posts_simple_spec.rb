require 'spec_helper'

describe 'End 2 End API tests for blog post model' do

  it 'should return post as document objects' do
    BlogPostBuilder.new.create
    documents = SoupCMS::Api::DataService.model('sunitparekh', 'posts').fetch
    document = documents[0]
    expect(document).to be_kind_of(SoupCMS::Api::Document)
  end

  it 'should not return posts in draft state for published documents' do
    BlogPostBuilder.new.with({'state' => SoupCMS::Api::Document::DRAFT}).create
    BlogPostBuilder.new.with({'state' => SoupCMS::Api::Document::PUBLISHED}).create
    documents = SoupCMS::Api::DataService.model('sunitparekh', 'posts').published.fetch
    expect(documents.size).to eq(1)

  end

  it 'should by default sort on published date as latest posts' do
    time = Time.now.to_i
    id1 = BlogPostBuilder.new.with('publish_datetime' => (time-50000)).create
    id2 = BlogPostBuilder.new.with('publish_datetime' => (time-2000)).create
    documents = SoupCMS::Api::DataService.model('sunitparekh', 'posts').fetch
    expect(documents[0]['_id']).to eq(id2)
    expect(documents[1]['_id']).to eq(id1)
  end

  it 'should limit posts to 2 when specified' do
    5.times { BlogPostBuilder.new.create }
    documents = SoupCMS::Api::DataService.model('sunitparekh', 'posts').limit(2).fetch
    expect(documents.size).to eq(2)

  end

  it 'should by default limit to 10 published posts max' do
    20.times { BlogPostBuilder.new.create }
    documents = SoupCMS::Api::DataService.model('sunitparekh', 'posts').fetch
    expect(documents.size).to eq(10)
  end

end