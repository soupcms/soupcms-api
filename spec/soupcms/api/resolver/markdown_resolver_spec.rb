require 'spec_helper'

describe SoupCMS::Api::Resolver::MarkdownResolver do

  let (:application) { SoupCMS::Api::Model::Application.new('soupcms-test') }
  let (:context) { SoupCMS::Api::Model::RequestContext.new(application, { 'model_name' => 'posts' }) }

  it 'should parse simple markdown headings' do
    value = '## Getting started'
    result = SoupCMS::Api::Resolver::MarkdownResolver.new.resolve({ 'type' => 'markdown', 'value' => value},context)
    expect(result).to include('<h2>Getting started</h2>')
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
    result = SoupCMS::Api::Resolver::MarkdownResolver.new.resolve({ 'type' => 'markdown', 'value' => value},context)
    expect(result).to include('<h2>Getting started</h2>')
    expect(result).to include('<pre class="highlight ruby">')
    expect(result).to include('\'Password\'')
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
    result = SoupCMS::Api::Resolver::MarkdownResolver.new.resolve({ 'type' => 'markdown', 'value' => value},context)
    expect(result).to include('<h2>Getting started</h2>')
    expect(result).to include('<table>')
    expect(result).to include('</table>')
    expect(result).to include('First Header')
    expect(result).to include('<pre class="highlight ruby">')
    expect(result).to include('method_name')
  end

end



