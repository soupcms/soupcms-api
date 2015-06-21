require 'spec_helper'

include SoupCMS::Api::DocumentState

describe 'filters n sorting' do

  let (:context) { SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'}) }
  let(:posts) { SoupCMS::Api::DocumentRepository.new(context) }

  context 'filters based on tags' do
    it 'should return all the published documents matching tag' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1 tag2)}).create
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag2)}).create

      documents = posts.published.tags('tag1').fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['tags']).to match_array(['tag1', 'tag2'])
    end

    it 'should return all the draft documents matching tag' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag1 tag2), 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1), 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag3), 'latest' => true}).create

      documents = posts.drafts.tags('tag1').fetch_all

      expect(documents.size).to eq(2)
      expect([documents[0]['_id'], documents[1]['_id']]).to match_array([doc1, doc2])
    end

    it 'should return all the published document matching multiple tags' do
      doc1 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1 tag2), 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1), 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag3), 'latest' => true}).create

      documents = posts.published.tags('tag2','tag3').fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc1)
    end

    it 'should return all the draft document matching multiple tags' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag1 tag2), 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'tags' => %w(tag1), 'latest' => true}).create
      doc3 = BlogPostBuilder.new.with({'state' => DRAFT, 'tags' => %w(tag3), 'latest' => true}).create

      documents = posts.drafts.tags('tag2','tag3').fetch_all

      expect(documents.size).to eq(2)
      expect([documents[0]['_id'], documents[1]['_id']]).to match_array([doc1, doc3])
    end
  end

  context 'PUBLISHED post by slug' do
    it 'should return post matching slug' do
      doc1 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-first-post'}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-second-post'}).create

      documents = posts.published.with('slug' => 'my-first-post').fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc1)
    end
    it 'should return ZERO post matching slug' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'slug' => 'my-first-post'}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-second-post'}).create

      documents = posts.published.with('slug' => 'my-first-post').fetch_all

      expect(documents.size).to eq(0)
    end
  end

  context 'DRAFT post by slug' do
    it 'should return post matching slug' do
      doc1 = BlogPostBuilder.new.with({'state' => DRAFT, 'slug' => 'my-first-post', 'latest' => true}).create
      doc2 = BlogPostBuilder.new.with({'state' => PUBLISHED, 'slug' => 'my-second-post', 'latest' => true}).create

      documents = posts.drafts.with('slug' => 'my-first-post').fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc1)
    end
  end

  context 'filters based on any document specific fields' do
    it 'should return published document matching title of the document' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'title' => 'My first blog post'}).create

      documents = posts.published.with('title' => 'My first blog post').fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['title']).to eq('My first blog post')
    end

    it 'should return zero document matching title of the document' do
      BlogPostBuilder.new.with({'state' => DRAFT, 'title' => 'My first blog post'}).create
      documents = posts.published.with('title' => 'My first blog post').fetch_all
      expect(documents.size).to eq(0)
    end

    it 'should return draft document matching title of the document' do
      doc1 = BlogPostBuilder.new.with({'doc_id' => 1234, 'state' => PUBLISHED, 'title' => 'My first blog post', 'latest' => false}).create
      doc2 = BlogPostBuilder.new.with({'doc_id' => 1234, 'state' => DRAFT, 'title' => 'My first blog post', 'latest' => true}).create

      documents = posts.drafts.with('title' => 'My first blog post').fetch_all

      expect(documents.size).to eq(1)
      expect(documents[0]['_id']).to eq(doc2)
    end


    it 'should return document matching regular expression on title field' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'title' => 'My first blog post'}).create
      documents = posts.published.with('title' => /blog/ ).fetch_all
      expect(documents.size).to eq(1)
      expect(documents[0]['title']).to eq('My first blog post')
    end

    it 'should allow multiple filters' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'title' => 'My first blog post','slug' => 'my-first-blog'}).create
      documents = posts.published.with('title' => /blog/ ).with('slug' => 'my-first-blog').fetch_all
      expect(documents.size).to eq(1)
      expect(documents[0]['title']).to eq('My first blog post')
    end
  end

  context 'sorting' do
    it 'should return documents sorted based on specified field and order' do
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'title' => 'B My first blog post'}).create
      BlogPostBuilder.new.with({'state' => PUBLISHED, 'title' => 'A My second blog post'}).create
      documents = posts.published.sort({'title' => 1}).fetch_all
      expect(documents.size).to eq(2)
      expect(documents[0]['title']).to eq('A My second blog post')
      expect(documents[1]['title']).to eq('B My first blog post')
    end
  end


end