module SoupCMS
  module Api
    module Resolver


      class LinkResolver < Base

        def resolve(value,context)
          return value unless value.kind_of?(Hash)
          URI.escape("/#{context.application.name}/#{SoupCMS::Api::Utils::UrlBuilder.build(value['model_name'],value['match'])}")
        end
      end

    end
  end
end
