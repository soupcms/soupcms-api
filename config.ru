require 'soupcms/api'
require 'rack/cache'

use Rack::Cache,
    :metastore   => 'heap:/',
    :entitystore => 'heap:/',
    :verbose     => false

SoupCMSApi.configure do |config|
  config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
end

run SoupCMSApiRackApp.new