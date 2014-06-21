module SoupCMS
  module Api
    module Enricher


      class UrlEnricher < Base

        def enrich(model)
          return if model['url']
          return unless model['slug']

          case context.model_name
            when 'pages'
              url = File.join(context.application.app_base_url, model['slug'])
            when 'chapters'
              url = File.join(context.application.app_base_url, context.model_name, model['release'], model['slug'])
            else
              url = File.join(context.application.app_base_url, context.model_name, model['slug'])
          end
          model['url'] = context.drafts? ? URI.escape(url + '?include=drafts') : URI.escape(url)
        end

      end


    end
  end
end