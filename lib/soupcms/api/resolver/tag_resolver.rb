module SoupCMS
  module Api
    module Resolver


      class TagResolver < Base

        def resolve(values,context)
          values.collect do |value|
            tag = {}
            tag['label'] = value
            tag['link'] = URI.escape("/#{context.application.name}/#{SoupCMS::Api::Utils::UrlBuilder.build(context.model_name,{'tags' => value})}")
            tag
          end
        end

      end

    end
  end
end
