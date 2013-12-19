require 'spec_helper'

describe SoupCMS::Api::Enricher::UrlEnricher do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }

  context 'pages' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'pages' }) }

    it 'should build and add url without model name to the page object when slug is present' do
      document = { 'title' => 'Title', 'slug' => 'latest' }
      SoupCMS::Api::Enricher::UrlEnricher.new(context).enrich(document)
      expect(document['url']).not_to be_nil
      expect(document['url']).to eq('/soupcms-test/latest')
    end

    it 'should not add any url the page object when slug is not present' do
      document = { 'title' => 'Title' }
      SoupCMS::Api::Enricher::UrlEnricher.new(context).enrich(document)
      expect(document['url']).to be_nil
    end

  end

  context 'posts' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'posts' }) }

    it 'should build and add url with model name to the post object when slug is present' do
      document = { 'title' => 'Title', 'slug' => 'first-post' }
      SoupCMS::Api::Enricher::UrlEnricher.new(context).enrich(document)
      expect(document['url']).not_to be_nil
      expect(document['url']).to eq('/soupcms-test/posts/first-post')
    end

    it 'should not add any url the post object when slug is not present' do
      document = { 'title' => 'Title' }
      SoupCMS::Api::Enricher::UrlEnricher.new(context).enrich(document)
      expect(document['url']).to be_nil
    end

  end

end