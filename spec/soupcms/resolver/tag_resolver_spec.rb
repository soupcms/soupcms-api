require 'spec_helper'

describe SoupCMS::Api::Resolver::LinkResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'posts' }) }

  it 'should resolve link dependency' do
    value = %w(popular agile)
    result = SoupCMS::Api::Resolver::TagResolver.new.resolve(value,context)
    expect(result.size).to eq(2)
    expect(result[0]['label']).to eq('popular')
    expect(result[0]['link']).to eq(URI.escape('/soupcms-test/posts?tags="popular"'))
    expect(result[1]['label']).to eq('agile')
    expect(result[1]['link']).to eq(URI.escape('/soupcms-test/posts?tags="agile"'))
  end

end



