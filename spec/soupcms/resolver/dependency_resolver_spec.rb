require 'spec_helper'

describe SoupCMS::Api::DependencyResolver do

  let (:application) { SoupCMS::Api::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::RequestContext.new(application) }

  it 'should resolve link dependency' do
    document = {
        'title' => 'Title',
        'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
    }
    expected = {
        'title' => 'Title',
        'link' => '/soupcms-test/posts?tags="popular"'
    }
    actual = SoupCMS::Api::DependencyResolver.new(context).resolve(document)
    expect(actual).to eq(expected)
  end

  it 'should resolve link dependency within array' do
    document = {
        'title' => 'Title',
        'menu' => [
            {
                'label' => 'Menu 1',
                'link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
            }
        ]
    }
    expected = {
        'title' => 'Title',
        'menu' => [
            {
                'label' => 'Menu 1',
                'link' => '/soupcms-test/posts?tags="popular"'
            }
        ]
    }
    actual = SoupCMS::Api::DependencyResolver.new(context).resolve(document)
    expect(actual).to eq(expected)
  end

  it 'should resolve link with key ending with link' do
    document = {
        'title' => 'Title',
        'title_link' => {'model_name' => 'posts', 'match' => {'tags' => 'popular'}}
    }
    expected = {
        'title' => 'Title',
        'title_link' => '/soupcms-test/posts?tags="popular"'
    }
    actual = SoupCMS::Api::DependencyResolver.new(context).resolve(document)
    expect(actual).to eq(expected)
  end

end



