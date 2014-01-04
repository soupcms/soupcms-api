require 'spec_helper'

describe SoupCMS::Api::Resolver::ReferenceResolver do

  let (:context) { SoupCMS::Api::Model::RequestContext.new(application) }

  before(:each) do
    BlogPostBuilder.new.with('create_datetime' => 1305000000, 'state' => SoupCMS::Api::DocumentState::PUBLISHED, 'title' => 'Title 1', 'slug' => 'title_1', 'latest' => true).create
  end

  it 'should resolve reference of other models' do
    value = {'model' => 'posts', 'match' => {'title' => 'Title 1'} }
    result, continue = SoupCMS::Api::Resolver::ReferenceResolver.new.resolve(value, context)
    expect(continue).to eq(true)
    expect(result['slug']).to eq('title_1')
    expect(result['model']).to be_nil
    expect(result['match']).to be_nil
  end

  it 'should return value as is if model is not specified' do
    value = {'model' => 'posts', 'some_other_field' => 'present' }
    result, continue = SoupCMS::Api::Resolver::ReferenceResolver.new.resolve(value, context)
    expect(continue).to eq(true)
    expect(result['some_other_field']).to eq('present')
    expect(result['model']).to eq('posts')
    expect(result['slug']).to be_nil
  end

  it 'should return value as is if match filter is not specified' do
    value = {'match' => {'title' => 'Title 1'}, 'some_other_field' => 'present' }
    result, continue = SoupCMS::Api::Resolver::ReferenceResolver.new.resolve(value, context)
    expect(continue).to eq(true)
    expect(result['some_other_field']).to eq('present')
    expect(result['match']).to eq({'title' => 'Title 1'})
    expect(result['slug']).to be_nil
  end
end