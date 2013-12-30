require 'spec_helper'

describe SoupCMS::Api::Resolver::LinkResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }

  context 'build published links' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application) }

    it 'should resolve link dependency' do
      value = {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
      result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
      expect(continue).to eq(false)
      expect(result['url']).to eq(URI.escape('/soupcms-test/posts?tags=popular'))
    end

    it 'should return value if it is absolute url and not a hash' do
      value = { 'url' => 'http://www.google.com/' }
      result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
      expect(continue).to eq(true)
      expect(result['url']).to eq('http://www.google.com/')
    end

    it 'should return value if it url stats with /' do
      value = { 'url' => '/app-name/test' }
      result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
      expect(continue).to eq(true)
      expect(result['url']).to eq('/app-name/test')
    end
  end

  context 'build drafts links' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'include' => 'drafts'} ) }

    it 'should add drafts to the url when context is drafts' do
      value = {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
      result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
      expect(continue).to eq(false)
      expect(result['url']).to eq(URI.escape('/soupcms-test/posts?tags=popular&include=drafts'))
    end

  end

  it 'build url using context model when model is not present in the link container hash' do
    context = SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'abcd'})
    value = { 'match' => {'tags' => 'popular'}}
    result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
    expect(continue).to eq(false)
    expect(result['url']).to eq(URI.escape('/soupcms-test/abcd?tags=popular'))

  end

  it 'should add application name if url is not absolute and application name not prefixed' do
    context = SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'abcd'})
    value = { 'url' => 'home' }
    result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
    expect(continue).to eq(false)
    expect(result['url']).to eq('/soupcms-test/home')
  end

  it 'should include drafts if url is not absolute and application name not prefixed' do
    context = SoupCMS::Api::Model::RequestContext.new(application, { 'include' => 'drafts' })
    value = { 'url' => 'home' }
    result, continue = SoupCMS::Api::Resolver::LinkResolver.new.resolve(value, context)
    expect(continue).to eq(false)
    expect(result['url']).to eq('/soupcms-test/home?include=drafts')
  end


end



