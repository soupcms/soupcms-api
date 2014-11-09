require 'json'
require 'soupcms/common'

require 'soupcms/api/version'

require 'soupcms/api/controller/model_controller'
require 'soupcms/api/controller/tag_cloud_controller'
require 'soupcms/api/controller/multi_key_value_controller'

require 'soupcms/api/route/multi_key_value_route'

require 'soupcms/api/resolver/data_resolver'
require 'soupcms/api/resolver/base'
require 'soupcms/api/resolver/link_resolver'
require 'soupcms/api/resolver/tag_resolver'
require 'soupcms/api/resolver/value_reference_resolver'
require 'soupcms/api/resolver/markdown/image_ref'
require 'soupcms/api/resolver/markdown/link_ref'

begin
  require 'redcarpet'
  require 'coderay'
  require 'soupcms/api/resolver/redcarpet_markdown_resolver'
rescue LoadError
  #puts "To load redcarpet_markdown_resolver add gems 'redcarpet' and 'coderay'"
end
begin
  require 'kramdown'
  require 'soupcms/api/resolver/kramdown_markdown_resolver'
rescue LoadError
  #puts "To load kramdown_markdown_resolver add gems 'kramdown'"
end

require 'soupcms/api/enricher/base'
require 'soupcms/api/enricher/page_enricher'
require 'soupcms/api/enricher/url_enricher'

require 'soupcms/api/utils/params_hash'
require 'soupcms/api/utils/config'

require 'soupcms/api/model/document'
require 'soupcms/api/model/documents'
require 'soupcms/api/model/tag_cloud'
require 'soupcms/api/model/document_repository'

require 'soupcms/api/service/document_service'
require 'soupcms/soupcms_api_rack_app'
require 'soupcms/soupcms_api'