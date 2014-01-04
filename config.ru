require 'soupcms/api'
require 'rack/cache'

use Rack::Cache,
    :metastore   => 'heap:/',
    :entitystore => 'heap:/',
    :verbose     => false

SoupCMSApi.configure do |config|
  SoupCMS::Api::Strategy::Application::SingleApp.configure do |app|
    app.app_name = 'soupcms-test'
    app.display_name = 'soupCMS Test'
    app.soupcms_api_url = 'http://localhost:9292/api'
    app.app_base_url = 'http://localhost:9291/'
  end
  config.application_strategy = SoupCMS::Api::Strategy::Application::SingleApp

  config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
  config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::KramdownMarkdownResolver)
end

run SoupCMSApiRackApp.new