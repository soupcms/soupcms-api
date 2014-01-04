require 'spec_helper'

include SoupCMS::Api::DocumentState

describe 'locale' do

  let (:context) { SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'}) }
  let(:posts) { SoupCMS::Api::DocumentRepository.new(context) }

  it 'should return en_US locale documents by default' do
    doc1 = BlogPostBuilder.new.with({'doc_id' => 1234, 'locale' => 'en_US', 'latest' => true, 'version' => 1}).create
    doc2 = BlogPostBuilder.new.with({'doc_id' => 1234, 'locale' => 'en_GB', 'latest' => true, 'version' => 2}).create

    documents = posts.drafts.fetch_all

    expect(documents.size).to eq(1)
    expect(documents[0]['_id']).to eq(doc1)
  end

  it 'should return specific locale documents' do
    doc1 = BlogPostBuilder.new.with({'doc_id' => 1234, 'locale' => 'en_US', 'latest' => true, 'version' => 1}).create
    doc2 = BlogPostBuilder.new.with({'doc_id' => 1234, 'locale' => 'en_GB', 'latest' => true, 'version' => 2}).create

    documents = posts.drafts.locale('en_GB').fetch_all

    expect(documents.size).to eq(1)
    expect(documents[0]['_id']).to eq(doc2)
  end


end