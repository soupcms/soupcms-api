module SoupCMS
  module Api
    module Resolver


      class LinkResolver < Base

        def resolve(value,context)
          return value, true if !value.kind_of?(Hash) || value['url']
          url = SoupCMS::Api::Utils::UrlBuilder.build(value['model_name'] || context.model_name, value['match'])
          if context.drafts?
            url.include?('?') ? url.concat('&') : url.concat('?')
            url = url.concat('include=drafts')
          end
          value['url'] = URI.escape("/#{context.application.name}/#{url}")
          return value, false
        end
      end

    end
  end
end
