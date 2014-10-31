require 'spec_helper'

describe SoupCMS::Api::Resolver::KramdownMarkdownResolver do

  let (:context) { SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'}) }


  context 'type = markdown and flavor = kramdown' do
    it 'should parse simple markdown headings' do
      value = '## Getting started'
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2 id="getting-started">Getting started</h2>')
    end

    it 'should parse fenced code blocks markdown' do
      value = <<-markdowm
## Getting started

```ruby
  table 'User' do
    anonymize('Password') { |field| "password" }
    anonymize('email') do |field|
        "test@gmail.com"
    end
  end
```
      markdowm
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2 id="getting-started">Getting started</h2>')
      expect(result['value']).to include('<code>')
      expect(result['value']).to include('Password')
    end

    it 'should parse tables markdown' do
      value = <<-markdowm
## Getting started

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell

```ruby
  def method_name(param1, param2)
    puts "param1: \#{param1}"
    puts "param2: \#{param2}"
  end
```
      markdowm
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2 id="getting-started">Getting started</h2>')
      expect(result['value']).to include('<table>')
      expect(result['value']).to include('</table>')
      expect(result['value']).to include('First Header')
      expect(result['value']).to include('<code>')
      expect(result['value']).to include('method_name')
    end
  end

  context 'image markdown syntax' do

    it 'should not resolve not referenced images' do
      value = '![my image](http://www.soupcms.com/logo.png)'
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)

      expect(continue).to eq(false)
      expect(result['value']).to include('<img src="http://www.soupcms.com/logo.png" alt="my image">')
    end

    it 'should resolve referenced image having only desktop version' do
      ImageBuilder.new.with(
              'doc_id' => 'posts/first-post/abc.png',
              'desktop' => 'v1234/desktopMD5.png',
              'desktopMD5' => 'desktopMD5'
          ).create

      value = '![my image](ref:images:posts/first-post/abc.png)'
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)

      expect(continue).to eq(false)
      expect(result['value']).to include('<img alt="my image" data-src-desktop="http://cloudinary.com/v1234/desktopMD5.png" class="img-responsive default-responsive-image markdown-image ">')
    end

    it 'should resolve referenced image having all 3 versions' do
      ImageBuilder.new.with(
              'doc_id' => 'posts/first-post/abc.png',
              'desktop' => 'v1234/desktopMD5.png',
              'desktopMD5' => 'desktopMD5',
              'mobile' => 'v1234/mobileMD5.png',
              'mobileMD5' => 'mobileMD5',
              'tablet' => 'v1234/tabletMD5.png',
              'tabletMD5' => 'tabletMD5'
          ).create

      value = '![my image](ref:images:posts/first-post/abc.png)'
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)

      expect(continue).to eq(false)
      expect(result['value']).to include('<img alt="my image" data-src-desktop="http://cloudinary.com/v1234/desktopMD5.png" data-src-tablet="http://cloudinary.com/v1234/tabletMD5.png" data-src-mobile="http://cloudinary.com/v1234/mobileMD5.png" class="img-responsive default-responsive-image markdown-image ">')
    end

    it 'should resolve multiple referenced images' do
      ImageBuilder.new.with(
              'doc_id' => 'posts/first-post/abc.png',
              'desktop' => 'v1234/desktopMD5.png',
              'desktopMD5' => 'desktopMD5'
          ).create

      value = "![first image](ref:images:posts/first-post/abc.png)\n![second image](ref:images:posts/first-post/abc.png)"
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)

      expect(continue).to eq(false)
      expect(result['value']).to include('<img alt="first image" data-src-desktop="http://cloudinary.com/v1234/desktopMD5.png" class="img-responsive default-responsive-image markdown-image ">')
      expect(result['value']).to include('<img alt="second image" data-src-desktop="http://cloudinary.com/v1234/desktopMD5.png" class="img-responsive default-responsive-image markdown-image ">')
    end

  end


end



