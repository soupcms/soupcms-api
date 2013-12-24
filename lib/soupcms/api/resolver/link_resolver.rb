module SoupCMS
  module Api
    module Resolver


      class LinkResolver < Base

        def resolve(value, context)
          url = value['url'] || ''
          return value, true if !value.kind_of?(Hash) || url.match(/http/)

          url = File.join(url, (value['model_name'] || context.model_name)) if url.empty?
          url = File.join("/#{context.application.name}", url) unless url.include?(context.application.name)
          params = SoupCMS::Api::Utils::ParamsHash.new
          params.merge!(value['match'] || {})
          params[:include] = 'drafts' if context.drafts?
          query_params = params.to_query_params
          value['url'] = query_params.empty? ? URI.escape(url) : URI.escape(url + '?' + query_params)
          return value, false
        end
      end

    end
  end
end
