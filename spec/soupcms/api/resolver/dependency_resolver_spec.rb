require 'spec_helper'

describe SoupCMS::Api::DependencyResolver do

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
        'link' => '/soupcms-test/posts?tags=%22popular%22'
    }
    SoupCMS::Api::DependencyResolver.new(context).resolve(document)
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
                'link' => '/soupcms-test/posts?tags=%22popular%22'
            }
        ]
    }
    SoupCMS::Api::DependencyResolver.new(context).resolve(document)
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
        'title_link' => '/soupcms-test/posts?tags=%22popular%22'
    }
    SoupCMS::Api::DependencyResolver.new(context).resolve(document)
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
                'link' => '/soupcms-test/posts?tags=%22tag1%22'
            },
            {
                'label' => 'tag2',
                'link' => '/soupcms-test/posts?tags=%22tag2%22'
            }
        ]
    }
    SoupCMS::Api::DependencyResolver.new(context).resolve(document)
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
        'markdown_content' => "<h1>Getting started</h1>\n",
        'html_content' => {
            'type' => 'html',
            'value' => '<h1>Getting started</h1>'
        },
        'content' => {
            'value' => 'Getting started'
        }
    }
    SoupCMS::Api::DependencyResolver.new(context).resolve(document)
    expect(document.to_hash).to eq(expected)

  end

  it 'should pass through multiple resolvers if matched' do

  end

end



