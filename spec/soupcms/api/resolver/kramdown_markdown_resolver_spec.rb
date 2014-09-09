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

    it 'should parse and render referenced image' do
      value = '![my image]($abc.png$)'
      result, continue = SoupCMS::Api::Resolver::KramdownMarkdownResolver.new.resolve({'type' => 'markdown','flavor' => 'kramdown', 'value' => value}, context)

      expect(continue).to eq(false)
      expect(result['value']).to include('<img src="$abc.png$" alt="my image" />')
    end

  end


end



