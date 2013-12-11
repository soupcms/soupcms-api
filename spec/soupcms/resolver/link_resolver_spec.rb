require 'spec_helper'

describe SoupCMS::Api::Resolver::LinkResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application) }

  it 'should resolve link dependency' do
    value = { 'model_name' => 'posts', 'match' => { 'tags' => 'popular' } }
    result = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value,context)
    expect(result).to eq(URI.escape('/soupcms-test/posts?tags="popular"'))
  end

  it 'should return value if it is absolute url and not a hash' do
    value = 'http://www.google.com/'
    result = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value,context)
    expect(result).to eq('http://www.google.com/')

  end


end



