require 'soupcms/api'
require 'rack/cache'

use Rack::Cache,
    :metastore   => 'heap:/',
    :entitystore => 'heap:/',
    :verbose     => false

run SoupCMSApiRackApp.new