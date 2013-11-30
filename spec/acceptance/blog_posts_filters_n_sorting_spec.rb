require 'spec_helper'

include SoupCMS::Api::DocumentState

describe 'Data Service tests for different filters and sorting options on post model' do

  let(:posts) { SoupCMS::Api::DataService.model('soupcms-api-test', 'posts') }

  context 'filters based on tags' do
    it 'should return all the published documents matching tag' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1 tag2)}).create
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag2)}).create

      documents = posts.published.tags('tag1').fetch

      expect(documents.size).to eq(1)
      expect(documents[0]['tags']).to include('tag1', 'tag2')
    end

    it 'should return all the draft documents matching tag' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag1 tag2), 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1), 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag3), 'latest' => true}).create

      documents = posts.draft.tags('tag1').fetch

      expect(documents.size).to eq(2)
      expect([documents[0]['_id'], documents[1]['_id']]).to match_array([doc1, doc2])
    end

    it 'should return all the published document matching multiple tags' do
      doc1 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1 tag2), 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1), 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag3), 'latest' => true}).create

      documents = posts.published.tags('tag2','tag3').fetch

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc1)
    end

    it 'should return all the draft document matching multiple tags' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag1 tag2), 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1), 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag3), 'latest' => true}).create

      documents = posts.draft.tags('tag2','tag3').fetch

      expect(documents.size).to eq(2)
      expect([documents[0]['_id'], documents[1]['_id']]).to match_array([doc1, doc3])
    end
  end

  context 'PUBLISHED post by slug' do
    it 'should return post matching slug' do
      doc1 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-first-post'}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-second-post'}).create

      documents = posts.published.with('slug' => 'my-first-post').fetch

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc1)
    end
    it 'should return ZERO post matching slug' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'slug' => 'my-first-post'}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-second-post'}).create

      documents = posts.published.with('slug' => 'my-first-post').fetch

      expect(documents.size).to eq(0)
    end
  end

  context 'DRAFT post by slug' do
    it 'should return post matching slug' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'slug' => 'my-first-post', 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-second-post', 'latest' => true}).create

      documents = posts.draft.with('slug' => 'my-first-post').fetch

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc1)
    end
  end

  context 'filters based on any document specific fields' do
    it 'should return published document matching title of the document'
    it 'should return draft document matching title of the document'
    it 'should return document matching regular expression on title field'
  end

  context 'sorting' do
    it 'should return documents sorted based on specified field and order'
  end


end