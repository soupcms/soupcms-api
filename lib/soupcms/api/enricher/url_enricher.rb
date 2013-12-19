module SoupCMS
  module Api
    module Enricher


      class UrlEnricher < Base

        def enrich(page)
          return unless page['slug']

          (context.model_name == 'pages') ?
              page['url'] = File.join('/', context.application.name, page['slug']) :
              page['url'] = File.join('/', context.application.name, context.model_name, page['slug'])
        end

      end


    end
  end
end