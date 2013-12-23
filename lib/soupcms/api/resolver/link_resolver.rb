module SoupCMS
  module Api
    module Resolver


      class LinkResolver < Base

        def resolve(value,context)
          return value, true if !value.kind_of?(Hash) || (value['url'] && value['url'].match(/http/))
          url = value['url']
          url = SoupCMS::Api::Utils::UrlBuilder.build(value['model_name'] || context.model_name, value['match']) unless url
          url = File.join("/#{context.application.name}",url) unless url.include?(context.application.name)
          url = SoupCMS::Api::Utils::UrlBuilder.drafts(url, context.drafts?)
          value['url'] = URI.escape(url)
          return value, false
        end
      end

    end
  end
end
