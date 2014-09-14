require 'spec_helper'

describe SoupCMS::Api::DataResolver do

  let (:context) { SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'}) }

  it 'should resolve link dependency' do
    document_hash = {
        'title' => 'Title',
        'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected = {
        'title' => 'Title',
        'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}, 'url' => 'http://localhost:9292/soupcms-test/posts?tags=popular'}
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)
  end

  it 'should resolve link dependency within array' do
    document_hash = {
        'title' => 'Title',
        'menu' => [
            {
                'label' => 'Menu 1',
                'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
            }
        ]
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected = {
        'title' => 'Title',
        'menu' => [
            {
                'label' => 'Menu 1',
                'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}, 'url' => 'http://localhost:9292/soupcms-test/posts?tags=popular'}
            }
        ]
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)
  end

  it 'should resolve link with key ending with link' do
    document_hash = {
        'title' => 'Title',
        'title_link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected = {
        'title' => 'Title',
        'title_link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}, 'url' => 'http://localhost:9292/soupcms-test/posts?tags=popular'}
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)
  end

  it 'should resolve tags with links' do
    document_hash = {
        'tags' => %w(tag1 tag2)
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected = {
        'tags' => [
            {
                'label' => 'tag1',
                'link' => {'match' => {'tags' => 'tag1'},'url' => 'http://localhost:9292/soupcms-test/posts?tags=tag1'}
            },
            {
                'label' => 'tag2',
                'link' => {'match' => {'tags' => 'tag2'},'url' => 'http://localhost:9292/soupcms-test/posts?tags=tag2'}
            }
        ]
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)
  end

  it 'should resolve deep matching of keys and value' do
    document_hash = {
        'markdown_content' => {
            'type' => 'markdown',
            'flavor' => 'redcarpet',
            'value' => '# Getting started'
        },
        'html_content' => {
            'type' => 'html',
            'value' => '<h1>Getting started</h1>'
        },
        'content' => {
            'value' => 'Getting started'
        }
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected = {
        'markdown_content' => {
            'type' => 'markdown',
            'flavor' => 'redcarpet',
            'value' => "<h1 id=\"getting-started\">Getting started</h1>\n"
        },
        'html_content' => {
            'type' => 'html',
            'value' => '<h1>Getting started</h1>'
        },
        'content' => {
            'value' => 'Getting started'
        }
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)

  end

  it 'should continue when resolves return true for further dependency resolution' do
    context = SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'})
    document_hash = {
        'tags' => %w(popular agile)
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected ={
        'tags' =>
            [
                {
                    'label' => 'popular',
                    'link' => {'match' => {'tags' => 'popular'}, 'url' => 'http://localhost:9292/soupcms-test/posts?tags=popular'}
                },
                {
                    'label' => 'agile',
                    'link' => {'match' => {'tags' => 'agile'}, 'url' => 'http://localhost:9292/soupcms-test/posts?tags=agile'}
                }
            ]
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)

  end

  context 'value reference resolver' do
    before(:each) do
      BlogPostBuilder.new.with('create_datetime' => 1305000000, 'state' => SoupCMS::Api::DocumentState::PUBLISHED, 'title' => 'First Post', 'slug' => 'first_post', 'latest' => true, 'doc_id' => 'first_post').create
      BlogPostBuilder.new.with('create_datetime' => 1305000000, 'state' => SoupCMS::Api::DocumentState::PUBLISHED, 'title' => 'Second Post', 'slug' => 'second_post', 'latest' => true, 'doc_id' => 'second_post','third_post' => 'ref:posts:third_post').create

      BlogPostBuilder.new.with('create_datetime' => 1305000000, 'state' => SoupCMS::Api::DocumentState::PUBLISHED, 'title' => 'Third Post', 'slug' => 'third_post', 'latest' => true, 'doc_id' => 'third_post').create

    end

    it 'should resolve references at top level' do
      document_hash = {
          'my_first_post' => 'ref:posts:first_post',
          'title' => 'My first post'
      }
      document = SoupCMS::Api::Document.new(document_hash)
      SoupCMS::Api::DataResolver.new(context).resolve(document)
      expect(document['my_first_post']['title']).to eq('First Post')
    end


    it 'should resolve references at deep level' do
      document_hash = {
          'my_posts' => {
              'first' => 'ref:posts:first_post',
              'second' => 'ref:posts:second_post'
          },
          'title' => 'My first post'
      }
      document = SoupCMS::Api::Document.new(document_hash)
      SoupCMS::Api::DataResolver.new(context).resolve(document)
      expect(document['my_posts']['first']['title']).to eq('First Post')
      expect(document['my_posts']['second']['title']).to eq('Second Post')
    end

    it 'should resolve references within array' do
      document_hash = {
          'my_posts' => %w(ref:posts:first_post ref:posts:second_post),
          'title' => 'My first post'
      }
      document = SoupCMS::Api::Document.new(document_hash)
      SoupCMS::Api::DataResolver.new(context).resolve(document)
      expect(document['my_posts'][0]['title']).to eq('First Post')
      expect(document['my_posts'][1]['title']).to eq('Second Post')
    end


    it 'should continue to resolve referenced entity as well' do
      document_hash = {
          'my_post' => 'ref:posts:second_post',
          'title' => 'My first post'
      }
      document = SoupCMS::Api::Document.new(document_hash)
      SoupCMS::Api::DataResolver.new(context).resolve(document)
      expect(document['my_post']['title']).to eq('Second Post')
      expect(document['my_post']['third_post']['title']).to eq('Third Post')
    end

  end

end



