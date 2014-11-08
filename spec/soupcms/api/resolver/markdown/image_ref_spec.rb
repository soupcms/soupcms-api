require 'spec_helper'

describe SoupCMS::Api::Resolver::Markdown::ImageRef do

  context 'resolve responsive image reference' do

    before(:each) do
      ImageBuilder.new.with(
          'doc_id' => 'posts/first-post/abc.png',
          'desktop' => 'v1234/desktopMD5.png',
          'desktopMD5' => 'desktopMD5',
          'mobile' => 'v1234/mobileMD5.png',
          'mobileMD5' => 'mobileMD5',
          'tablet' => 'v1234/tabletMD5.png',
          'tabletMD5' => 'tabletMD5'
      ).create
    end

    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<img alt="my image" src="ref:images:posts/first-post/abc.png" class="full-width">' }
    let (:image_ref) { SoupCMS::Api::Resolver::Markdown::ImageRef.new }

    it 'should resolve image references for desktop' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('data-src-desktop="http://cloudinary.com/v1234/desktopMD5.png"')
    end

    it 'should resolve image references for mobile' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('data-src-mobile="http://cloudinary.com/v1234/mobileMD5.png"')
    end

    it 'should resolve image references for tablet' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('data-src-tablet="http://cloudinary.com/v1234/tabletMD5.png"')
    end

    it 'should retain existing classes' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('full-width')
    end

    it 'should add responsive image classes' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('img-responsive default-responsive-image markdown-image')
    end

  end


  context 'resolve non-responsive image reference' do
    before(:each) do
      ImageBuilder.new.with(
          'doc_id' => 'posts/first-post/abc.png',
          'desktop' => 'v1234/desktopMD5.png',
          'desktopMD5' => 'desktopMD5'
      ).create
    end

    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<img alt="my image" src="ref:images:posts/first-post/abc.png" class="full-width">' }
    let (:image_ref) { SoupCMS::Api::Resolver::Markdown::ImageRef.new }

    it 'should resolve image references for desktop' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('src="http://cloudinary.com/v1234/desktopMD5.png"')
    end

    it 'should retain existing classes' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('full-width')
    end

    it 'should add responsive image classes' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('img-responsive markdown-image ')
    end

  end

  context 'continue to work for non-referenced images' do
    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<img alt="my image" src="http://www.soupcms.com/logo.png" class="full-width">' }
    let (:image_ref) { SoupCMS::Api::Resolver::Markdown::ImageRef.new }

    it 'should continue without any reference resolution for non referenced images' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('src="http://www.soupcms.com/logo.png"')
    end


  context 'handle multiple images' do
    before(:each) do
      ImageBuilder.new.with(
          'doc_id' => 'posts/first-post/abc.png',
          'desktop' => 'v1234/desktopMD5abc.png',
          'desktopMD5' => 'desktopMD5'
      ).create
      ImageBuilder.new.with(
          'doc_id' => 'posts/first-post/xyz.png',
          'desktop' => 'v1234/desktopMD5xyz.png',
          'desktopMD5' => 'desktopMD5'
      ).create
    end

    let (:context) { SoupCMS::Common::Model::RequestContext.new(application) }
    let (:html_document) { '<img alt="my image" src="ref:images:posts/first-post/abc.png" class="full-width"><img alt="my image" src="ref:images:posts/first-post/xyz.png" class="full-width">' }
    let (:image_ref) { SoupCMS::Api::Resolver::Markdown::ImageRef.new }

    it 'should resolve image references for desktop' do
      result = image_ref.resolve(html_document, context)
      expect(result).to include('src="http://cloudinary.com/v1234/desktopMD5abc.png"')
      expect(result).to include('src="http://cloudinary.com/v1234/desktopMD5xyz.png"')
    end

  end


  end

end



