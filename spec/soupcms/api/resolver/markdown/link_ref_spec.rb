require 'spec_helper'
include SoupCMS::Api::DocumentState

describe SoupCMS::Api::Resolver::Markdown::LinkRef do

  context 'resolve responsive image reference' do

    before(:each) do
      BlogPostBuilder.new.with('slug' => 'my-first-post', 'doc_id' => 'first-post', 'state' => PUBLISHED).create
    end

    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<a href="ref:posts:first-post">' }
    let (:link_ref) { SoupCMS::Api::Resolver::Markdown::LinkRef.new(context) }

    it 'should resolve image references for desktop' do
      result = link_ref.resolve(html_document)
      expect(result).to include('href="http://localhost:9292/soupcms-test/posts/my-first-post"')
    end

  end

  context 'invalid reference' do

    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<a href="ref:posts:first-post">' }
    let (:link_ref) { SoupCMS::Api::Resolver::Markdown::LinkRef.new(context) }

    it 'should resolve image references for desktop' do
      result = link_ref.resolve(html_document)
      expect(result).to include('href="ref:posts:first-post"')
    end

  end

  context 'continue to work for non-referenced link' do
    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<a href="http://www.soupcms.com/home">' }
    let (:link_ref) { SoupCMS::Api::Resolver::Markdown::LinkRef.new(context) }

    it 'should continue without any reference resolution for absolute link' do
      result = link_ref.resolve(html_document)
      expect(result).to include('href="http://www.soupcms.com/home"')
    end

  end


end



