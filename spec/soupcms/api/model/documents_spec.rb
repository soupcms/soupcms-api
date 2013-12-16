require 'spec_helper'

describe SoupCMS::Api::Documents do

  it 'should replace document with higher version' do
    doc_v1 = SoupCMS::Api::Document.new({'doc_id' => 1, 'version' => 1})
    doc_v2 = SoupCMS::Api::Document.new({'doc_id' => 1, 'version' => 2})
    doc_v3 = SoupCMS::Api::Document.new({'doc_id' => 1, 'version' => 3})

    docs = SoupCMS::Api::Documents.new
    docs.add(doc_v1)
    docs.add(doc_v2)
    docs.add(doc_v3)

    expect(docs[0]).to eq(doc_v3)
  end

  it 'should not replace document with higher version' do
    doc_v4 = SoupCMS::Api::Document.new({'doc_id' => 1, 'version' => 4})
    doc_v3 = SoupCMS::Api::Document.new({'doc_id' => 1, 'version' => 3})

    docs = SoupCMS::Api::Documents.new
    docs.add(doc_v4)
    docs.add(doc_v3)

    expect(docs[0]).to eq(doc_v4)
  end
end