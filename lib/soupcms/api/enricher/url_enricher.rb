module SoupCMS
  module Api
    module Enricher


      class UrlEnricher < Base

        def enrich(model)
          return if model['url']
          return unless model['slug']

          model_name = model['model_name'] || context.model_name
          case model_name
            when 'pages'
              url = File.join(context.application.app_base_url, model['slug'])
            when 'chapters'
              url = File.join(context.application.app_base_url, model_name, model['release'], model['slug'])
            else
              url = File.join(context.application.app_base_url, model_name, model['slug'])
          end
          model['url'] = context.drafts? ? URI.escape(url + '?include=drafts') : URI.escape(url)
          model
        end

      end


    end
  end
end