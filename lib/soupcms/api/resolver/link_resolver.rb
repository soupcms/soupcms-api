module SoupCMS
  module Api
    module Resolver


      class LinkResolver < Base

        def resolve(value,context)
          return value unless value.kind_of?(Hash)
          url = SoupCMS::Api::Utils::UrlBuilder.build(value['model_name'], value['match'])
          if context.drafts?
            url.include?('?') ? url.concat('&') : url.concat('?')
            url = url.concat('include=drafts')
          end
          URI.escape("/#{context.application.name}/#{url}")
        end
      end

    end
  end
end
