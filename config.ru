require 'soupcms/api'
require 'rack/cache'

use Rack::Cache,
    :metastore   => 'heap:/',
    :entitystore => 'heap:/',
    :verbose     => true

run SoupCMSApi