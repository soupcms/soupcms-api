module SoupCMS
  module Api
    module Enricher


      class UrlEnricher < Base

        def enrich(page)
          return unless page['slug']

          url = (context.model_name == 'pages') ?
              File.join('/', context.application.name, page['slug']) :
              File.join('/', context.application.name, context.model_name, page['slug'])
          url = SoupCMS::Api::Utils::UrlBuilder.drafts(url, context.drafts?)
          page['url'] = URI.escape(url)
        end

      end


    end
  end
end