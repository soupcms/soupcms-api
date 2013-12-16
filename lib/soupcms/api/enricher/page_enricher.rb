module SoupCMS
  module Api
    module Enricher


      class PageEnricher < Base

        def enrich(page, context)
          return page unless context.model_name == 'pages'
          repo = SoupCMS::Api::DocumentRepository.new(context)
          repo.model_name = 'pages'
          enricher_page = repo.with({'meta.name' => 'enricher'}).fetch_one
          if page['layout'].nil? || page['layout'].empty?
            page.merge!({'layout' => enricher_page['layout']}) if enricher_page['layout']
          end
          page
        end


      end


    end
  end
end