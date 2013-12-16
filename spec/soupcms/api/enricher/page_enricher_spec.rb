require 'spec_helper'

describe SoupCMS::Api::Enricher::PageEnricher do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }

  context 'models other than pages' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'posts' }) }

    it 'should it should ignore all other models than pages' do
      document = { 'title' => 'Title' }
      SoupCMS::Api::Enricher::PageEnricher.new.enrich(document,context)
      expect(document.size).to eq(1)
    end
  end

  context 'pages model' do
    let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'pages' }) }

    it 'should add layout using default page when not present' do
      PageBuilder.enricher_page.create
      page = PageBuilder.any_page.build

      expect(page['layout']).to be_nil
      SoupCMS::Api::Enricher::PageEnricher.new.enrich(page,context)
      expect(page['layout']).not_to be_nil
    end

    it 'should add missing areas in page' do
      PageBuilder.enricher_page.create
      page = PageBuilder.any_page.build

      expect(page['areas'].size).to eq(1)
      SoupCMS::Api::Enricher::PageEnricher.new.enrich(page,context)
      expect(page['areas'].size).to eq(3)
    end

  end



end