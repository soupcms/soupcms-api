require 'spec_helper'

include SoupCMS::Api::DocumentState

describe 'basic' do

  let(:posts) { SoupCMS::Api::DataService.model('soupcms-api-test', 'posts') }


  it 'should return post as document objects' do
    BlogPostBuilder.new.with('state' => PUBLISHED).create
    documents = posts.fetch_all
    document = documents[0]
    expect(document).to be_kind_of(SoupCMS::Api::Document)
  end

  it 'should not return posts in draft state for published request' do
    BlogPostBuilder.new.with({'state' => DRAFT}).create
    BlogPostBuilder.new.with({'state' => PUBLISHED}).create
    documents = posts.published.fetch_all
    expect(documents.size).to eq(1)

  end

  it 'should by default sort on published date as latest posts' do
    time = Time.now.to_i
    id1 = BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => (time-50000)).create
    id2 = BlogPostBuilder.new.with('state' => PUBLISHED, 'publish_datetime' => (time-2000)).create
    documents = posts.fetch_all
    expect(documents[0]['_id']).to eq(id2)
    expect(documents[1]['_id']).to eq(id1)
  end

  it 'should limit posts to 2 when specified' do
    5.times { BlogPostBuilder.new.with('state' => PUBLISHED).create }
    documents = posts.limit(2).fetch_all
    expect(documents.size).to eq(2)

  end

  it 'should by default limit to 10 published posts max' do
    20.times { BlogPostBuilder.new.with('state' => PUBLISHED).create }
    documents = posts.fetch_all
    expect(documents.size).to eq(10)
  end

  it 'should by default return only published posts' do
    BlogPostBuilder.new.with({'state' => DRAFT}).create
    BlogPostBuilder.new.with({'state' => PUBLISHED}).create
    documents = posts.fetch_all
    expect(documents.size).to eq(1)
  end

  it 'should return drafts as all documents draft, scheduled and published posts' do
    BlogPostBuilder.new.with({'state' => DRAFT, 'latest' => true}).create
    BlogPostBuilder.new.with({'state' => PUBLISHED, 'latest' => true}).create
    BlogPostBuilder.new.with({'state' => SCHEDULED, 'latest' => true}).create
    documents = posts.drafts.fetch_all
    expect(documents.size).to eq(3)
  end

end