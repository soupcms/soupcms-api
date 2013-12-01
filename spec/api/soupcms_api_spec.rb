require 'spec_helper'
require 'rack/test'

include SoupCMS::Api::DocumentState

describe 'API' do
  include Rack::Test::Methods

  def app
    SoupCMS::ModelAPI
  end

  context 'get request for published documents' do
    before do
      20.times { BlogPostBuilder.new.with('state' => PUBLISHED).create }
      get '/api/soupcms-api-test/posts'
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(JSON.parse(last_response.body).length).to eq(10) }
  end

end