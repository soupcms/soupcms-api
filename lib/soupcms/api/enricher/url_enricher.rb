module SoupCMS
  module Api
    module Enricher


      class UrlEnricher < Base

        def enrich(page)
          return unless page['slug']

          url = (context.model_name == 'pages') ?
              File.join(context.application.app_base_url, page['slug']) :
              File.join(context.application.app_base_url, context.model_name, page['slug'])

          page['url'] = context.drafts? ? URI.escape(url + '?include=drafts') : URI.escape(url)

        end

      end


    end
  end
end