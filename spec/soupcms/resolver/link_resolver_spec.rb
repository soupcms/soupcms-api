require 'spec_helper'

describe SoupCMS::Api::Resolver::LinkResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application) }

  it 'should resolve link dependency' do
    value = { 'model_name' => 'posts', 'match' => { 'tags' => 'popular' } }
    result = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value,context)
    expect(result).to eq('/soupcms-test/posts?tags="popular"')
  end


end



