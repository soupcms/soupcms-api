module SoupCMS
  module Api
    module Resolver


      class TagResolver < Base

        def resolve(values,context)
          values.collect do |value|
            tag = {}
            tag['label'] = value
            tags_url = SoupCMS::Api::Utils::UrlBuilder.build(context.model_name, {'tags' => value})
            tag['link'] = URI.escape("/#{context.application.name}/#{tags_url}")
            tag
          end
        end

      end

    end
  end
end
