require 'spec_helper'

describe SoupCMS::Api::Resolver::RedcarpetMarkdownResolver do

  let (:context) { SoupCMS::Common::Model::RequestContext.new(application, {'model_name' => 'posts'}) }
  context 'type = markdown' do
    it 'should parse simple markdown headings' do
      value = '## Getting started'
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'redcarpet', 'value' => value}, context)
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
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'redcarpet', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2 id="getting-started">Getting started</h2>')
      expect(result['value']).to include('<div class="CodeRay">')
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
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'redcarpet', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2 id="getting-started">Getting started</h2>')
      expect(result['value']).to include('<table>')
      expect(result['value']).to include('</table>')
      expect(result['value']).to include('First Header')
      expect(result['value']).to include('<div class="CodeRay">')
      expect(result['value']).to include('method_name')
    end
  end

  context 'type != markdown' do

    it 'should return value as is' do
      value = '## Getting started'
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'not-markdown', 'value' => value}, context)
      expect(continue).to eq(true)
      expect(result['value']).to include('## Getting started')

    end
  end

  context 'image markdown syntax' do

    it 'should resolve referenced image' do
      ImageBuilder.new.with(
          'doc_id' => 'posts/first-post/abc.png',
          'desktop' => 'v1234/desktopMD5.png',
          'desktopMD5' => 'desktopMD5'
      ).create

      value = '![my image](ref:images:posts/first-post/abc.png)'
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'redcarpet', 'value' => value}, context)

      expect(continue).to eq(false)
      expect(result['value']).to include('<img src="http://cloudinary.com/v1234/desktopMD5.png" alt="my image" class="img-responsive markdown-image ">')
    end

  end


end



