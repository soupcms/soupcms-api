require 'spec_helper'
require 'rack/request'
require 'rack/mock'

describe SoupCMS::Api::Strategy::Application::SingleApp do

  before(:each) do
    SoupCMS::Api::Strategy::Application::SingleApp.app_name = 'soupcms-test'
    SoupCMS::Api::Strategy::Application::SingleApp.app_base_url = 'http://example.com:8081/soupcms-test'
  end

  let(:app_strategy) { SoupCMS::Api::Strategy::Application::SingleApp.new(Rack::Request.new(Rack::MockRequest.env_for('http://example.com:8080/api/posts/slug/my-first-blog-post?include=drafts'))) }

  it { expect(app_strategy.app_name).to eq('soupcms-test') }
  it { expect(app_strategy.path).to eq('posts/slug/my-first-blog-post') }
  it { expect(app_strategy.app_base_url).to eq('http://example.com:8081/soupcms-test') }
  it { expect(app_strategy.not_found_message).to eq("Page 'posts/slug/my-first-blog-post' not found in application 'soupcms-test'") }

end