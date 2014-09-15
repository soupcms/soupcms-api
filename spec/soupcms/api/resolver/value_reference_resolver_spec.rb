require 'spec_helper'

describe SoupCMS::Api::Resolver::ValueReferenceResolver do

  let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }

  before(:each) do
    BlogPostBuilder.new.with('create_datetime' => 1305000000, 'state' => SoupCMS::Api::DocumentState::PUBLISHED, 'title' => 'Title 1', 'slug' => 'title_1', 'latest' => true, 'doc_id' => 'first_post').create
  end

  it 'should resolve reference of other models' do
    value = 'ref:posts:first_post'
    result, continue = SoupCMS::Api::Resolver::ValueReferenceResolver.new.resolve(value, context)
    expect(continue).to eq(true)
    expect(result['doc_id']).to eq('first_post')
    expect(result['slug']).to eq('title_1')
    expect(result['title']).to eq('Title 1')
  end

  it 'should return value back when could not resolve reference' do
    value = 'ref:posts:second_post'
    result, continue = SoupCMS::Api::Resolver::ValueReferenceResolver.new.resolve(value, context)
    expect(result).to eq('ref:posts:second_post')

  end

end