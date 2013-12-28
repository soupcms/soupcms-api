require 'spec_helper'

describe SoupCMS::Api::Resolver::RedcarpetMarkdownResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application, {'model_name' => 'posts'}) }
  context 'type = markdown' do
    it 'should parse simple markdown headings' do
      value = '## Getting started'
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2>Getting started</h2>')
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
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2>Getting started</h2>')
      expect(result['value']).to include('<pre class="highlight ruby">')
      expect(result['value']).to include('\'Password\'')
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
      result, continue = SoupCMS::Api::Resolver::RedcarpetMarkdownResolver.new.resolve({'type' => 'markdown', 'value' => value}, context)
      expect(continue).to eq(false)
      expect(result['value']).to include('<h2>Getting started</h2>')
      expect(result['value']).to include('<table>')
      expect(result['value']).to include('</table>')
      expect(result['value']).to include('First Header')
      expect(result['value']).to include('<pre class="highlight ruby">')
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


end



