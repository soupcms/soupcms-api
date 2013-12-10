module SoupCMS
  module Api
    module Resolver


      class LinkResolver < Base

        def resolve(value,context)
          "/#{context.application.name}/#{SoupCMS::Api::Utils::UrlBuilder.build(value['model_name'],value['match'])}"
        end
      end

    end
  end
end
