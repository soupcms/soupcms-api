require 'spec_helper'

describe SoupCMS::Api::Enricher::PageEnricher do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }

  context 'models other than pages' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'posts' }) }

    it 'should be ignored' do
      document = { 'title' => 'Title' }
      SoupCMS::Api::Enricher::PageEnricher.new(context).enrich(document)
      expect(document.size).to eq(1)
    end
  end

  context 'pages model' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'pages' }) }

    it 'should add layout using enricher page when not present' do
      PageBuilder.enricher_page.create
      page = PageBuilder.any_page.build

      expect(page['layout']).to be_nil
      SoupCMS::Api::Enricher::PageEnricher.new(context).enrich(page)
      expect(page['layout']).not_to be_nil
    end

    it 'should add missing areas in page using enricher page' do
      PageBuilder.enricher_page.create
      page = PageBuilder.any_page.build

      expect(page['areas'].size).to eq(1)
      SoupCMS::Api::Enricher::PageEnricher.new(context).enrich(page)
      expect(page['areas'].size).to eq(3)
    end

  end

  context 'use draft enricher' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'pages', 'include' => 'drafts' }) }

    it 'should load draft version when context is drafts' do
      PageBuilder.enricher_page.with({'state' => SoupCMS::Api::DocumentState::DRAFT, 'latest' => true}).create
      page = PageBuilder.any_page.build

      expect(page['areas'].size).to eq(1)
      SoupCMS::Api::Enricher::PageEnricher.new(context).enrich(page)
      expect(page['areas'].size).to eq(3)
    end

  end



end