require 'spec_helper'

describe SoupCMS::Api::DataResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application, {'model_name' => 'posts'}) }

  it 'should resolve link dependency' do
    document_hash = {
        'title' => 'Title',
        'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected = {
        'title' => 'Title',
        'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}, 'url' => '/soupcms-test/posts?tags=popular'}
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
                'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}, 'url' => '/soupcms-test/posts?tags=popular'}
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
        'title_link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}, 'url' => '/soupcms-test/posts?tags=popular'}
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
                'link' => {'match' => {'tags' => 'tag1'},'url' => '/soupcms-test/posts?tags=tag1'}
            },
            {
                'label' => 'tag2',
                'link' => {'match' => {'tags' => 'tag2'},'url' => '/soupcms-test/posts?tags=tag2'}
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
            'value' => "<h1>Getting started</h1>\n"
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
    context = SoupCMS::Api::Model::RequestContext.new(application, {'model_name' => 'posts'})
    document_hash = {
        'tags' => %w(popular agile)
    }
    document = SoupCMS::Api::Document.new(document_hash)
    expected ={
        'tags' =>
            [
                {
                    'label' => 'popular',
                    'link' => {'match' => {'tags' => 'popular'}, 'url' => '/soupcms-test/posts?tags=popular'}
                },
                {
                    'label' => 'agile',
                    'link' => {'match' => {'tags' => 'agile'}, 'url' => '/soupcms-test/posts?tags=agile'}
                }
            ]
    }
    SoupCMS::Api::DataResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)

  end

end



