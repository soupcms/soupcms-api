require 'spec_helper'

describe SoupCMS::Api::Resolver::LinkResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'posts' }) }

  it 'should resolve link dependency' do
    value = %w(popular agile)
    result, continue = SoupCMS::Api::Resolver::TagResolver.new.resolve(value,context)
    expect(continue).to eq(true)
    expect(result.size).to eq(2)
    expect(result[0]['label']).to eq('popular')
    expect(result[0]['link']).to eq({'match' => {'tags' => 'popular'}})
    expect(result[1]['label']).to eq('agile')
    expect(result[1]['link']).to eq({'match' => {'tags' => 'agile'}})
  end

  it 'should not do anything is value is not an array' do
    value = { 'key' => 'value' }
    result, continue = SoupCMS::Api::Resolver::TagResolver.new.resolve(value,context)
    expect(continue).to eq(true)
    expect(result).to eq(value)
  end

end



