require 'spec_helper'

include SoupCMS::Api::DocumentState
include SoupCMS::Api::Model

describe 'resilience' do

  let (:application) { Application.new('soupcms-test') }
  let (:context) { RequestContext.new(application, {'model_name' => 'posts'}) }
  let(:posts) { SoupCMS::Api::DataService.model(context) }

  context 'having multiple published version of a document' do
    it 'should return only latest published document' do
      doc1 = BlogPostBuilder.new.with({'create_datetime' => 1305000000, 'doc_id' => 1234, 'state' => ARCHIVE, 'version' => 1, 'latest' => false}).create
      doc4 = BlogPostBuilder.new.with({'create_datetime' => 1305300000, 'doc_id' => 1234, 'state' => PUBLISHED, 'publish_datetime' => 1306000000, 'version' => 4, 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'create_datetime' => 1305100000, 'doc_id' => 1234, 'state' => DRAFT, 'version' => 2, 'latest' => false}).create
      doc3 = BlogPostBuilder.new.with({'create_datetime' => 1305400000, 'doc_id' => 1234, 'state' => PUBLISHED, 'publish_datetime' => 1305000000, 'version' => 10, 'latest' => false}).create
      doc5 = BlogPostBuilder.new.with({'create_datetime' => 1305100000, 'doc_id' => 1234, 'state' => DRAFT, 'version' => 5, 'latest' => true}).create

      documents = posts.published.fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc4)
    end

  end

  context 'having multiple latest version of a document' do
    it 'should return only latest document' do
      doc1 = BlogPostBuilder.new.with({'create_datetime' => 1305000000, 'doc_id' => 1234, 'state' => ARCHIVE, 'version' => 1, 'latest' => false}).create
      doc2 = BlogPostBuilder.new.with({'create_datetime' => 1305100000, 'doc_id' => 1234, 'state' => DRAFT, 'version' => 2, 'latest' => false}).create
      doc4 = BlogPostBuilder.new.with({'create_datetime' => 1306000000, 'doc_id' => 1234, 'state' => PUBLISHED, 'publish_datetime' => 1305200000, 'version' => 4, 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'create_datetime' => 1305300000, 'doc_id' => 1234, 'state' => DRAFT, 'version' => 3, 'latest' => true}).create

      documents = posts.drafts.fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc4)
    end

  end

  context 'conflicting filters' do
    it 'should return published documents' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'latest' => false}).create
      documents = posts.drafts.published.fetch_all
      expect(documents.size).to eq(1)
    end
    it 'should return draft documents' do
      BlogPostBuilder.new.with({'state' => DRAFT, 'latest' => true}).create
      documents = posts.published.drafts.fetch_all
      expect(documents.size).to eq(1)
    end
  end


end