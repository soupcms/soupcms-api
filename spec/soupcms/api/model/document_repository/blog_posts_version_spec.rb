require 'spec_helper'

include SoupCMS::Api::DocumentState

describe 'versions' do

  let(:context) { SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'}) }
  let(:service) { SoupCMS::Api::DocumentRepository.new(context) }

  it 'should return only one latest published blog post for multiple versions of posts' do
    time = Time.now.to_i
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => DRAFT, 'publish_datetime' => (time-50000)}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => ARCHIVE,'publish_datetime' => (time-45000)}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => ARCHIVE,'publish_datetime' => (time-40000)}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => PUBLISHED,'publish_datetime' => (time-35000)}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => DRAFT,'publish_datetime' => (time-30000)}).create
    BlogPostBuilder.new.with({'doc_id' => 23345,'state' => DRAFT,'publish_datetime' => (time-25000)}).create

    document = service.doc_id(1234).published.fetch_one
    expect(document['state']).to eq(PUBLISHED)
    expect(document['publish_datetime']).to eq(time-35000)

  end

  context 'when multiple version of the document exist' do
    it 'should return the latest DRAFT version' do
      time = Time.now.to_i
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => DRAFT, 'version' => 1, 'latest' => false}).create
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => ARCHIVE, 'version' => 2, 'latest' => false}).create
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => DRAFT, 'version' => 4, 'latest' => true}).create
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => PUBLISHED, 'version' => 3, 'latest' => false}).create

      document = service.doc_id(1234).drafts.fetch_one

      expect(document['state']).to eq(DRAFT)
      expect(document['version']).to eq(4)
    end
    it 'should return the latest PUBLISHED version' do
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => DRAFT, 'version' => 1, 'latest' => false}).create
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => PUBLISHED, 'version' => 3, 'latest' => true}).create
      BlogPostBuilder.new.with({'doc_id' => 1234,'state' => ARCHIVE, 'version' => 2, 'latest' => false}).create

      document = service.doc_id(1234).drafts.fetch_one

      expect(document['state']).to eq(PUBLISHED)
      expect(document['version']).to eq(3)
    end
  end

  it 'should return all the latest published posts' do # works on the basis that for one document at a time only one version is in published state
    doc1_time = Time.now.to_i
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => ARCHIVE, 'version' => 1}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => PUBLISHED,'publish_datetime' => (doc1_time-35000), 'version' => 4}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => PUBLISHED_ARCHIVE,'publish_datetime' => (doc1_time-45000), 'version' => 2}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => SCHEDULED,'publish_datetime' => (doc1_time-40000), 'version' => 5}).create
    BlogPostBuilder.new.with({'doc_id' => 1234,'state' => DRAFT, 'version' => 6}).create

    doc2_time = doc1_time - 60000
    BlogPostBuilder.new.with({'doc_id' => 23345,'state' => DRAFT,'publish_datetime' => (doc2_time-15000)}).create
    BlogPostBuilder.new.with({'doc_id' => 23345,'state' => PUBLISHED,'publish_datetime' => (doc2_time-25000)}).create

    documents = service.published.fetch_all

    expect(documents.size).to eq(2)
    expect(documents[0]['publish_datetime']).to eq(doc1_time - 35000)
    expect(documents[1]['publish_datetime']).to eq(doc2_time - 25000)
  end

  it 'should return all the latest published and draft posts' do
    BlogPostBuilder.new.with({'create_datetime' => 1305000000, 'doc_id' => 1234,'state' => ARCHIVE, 'version' => 1, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1305100000, 'doc_id' => 1234,'state' => DRAFT,'publish_datetime' => 1305100000, 'version' => 2, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1305200000, 'doc_id' => 1234,'state' => PUBLISHED_ARCHIVE,'publish_datetime' => 1305200000, 'version' => 3, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1305300000, 'doc_id' => 1234,'state' => PUBLISHED,'publish_datetime' => 1305300000, 'version' => 4, 'latest' => true}).create

    BlogPostBuilder.new.with({'create_datetime' => 1306100000, 'doc_id' => 5678,'state' => ARCHIVE, 'version' => 1, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1306200000, 'doc_id' => 5678,'state' => PUBLISHED_ARCHIVE,'publish_datetime' => 1306200000, 'version' => 2, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1306300000, 'doc_id' => 5678,'state' => DRAFT,'publish_datetime' => 1306300000, 'version' => 3, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1306400000, 'doc_id' => 5678,'state' => PUBLISHED,'publish_datetime' => 1306400000, 'version' => 4, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1306500000, 'doc_id' => 5678,'state' => DRAFT,'version' => 5, 'latest' => true}).create

    BlogPostBuilder.new.with({'create_datetime' => 1307500000, 'doc_id' => 23345,'state' => DRAFT,'version' => 1, 'latest' => false}).create
    BlogPostBuilder.new.with({'create_datetime' => 1307600000, 'doc_id' => 23345,'state' => DRAFT,'version' => 2, 'latest' => true}).create

    documents = service.drafts.fetch_all

    expect(documents.size).to eq(3)
    expect(documents[2]['doc_id']).to eq(1234)
    expect(documents[2]['version']).to eq(4)

    expect(documents[1]['doc_id']).to eq(5678)
    expect(documents[1]['version']).to eq(5)

    expect(documents[0]['doc_id']).to eq(23345)
    expect(documents[0]['version']).to eq(2)
  end



end