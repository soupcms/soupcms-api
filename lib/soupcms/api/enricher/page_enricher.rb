module SoupCMS
  module Api
    module Enricher


      class PageEnricher < Base

        def initialize(context)
          @context = context
        end

        attr_reader :context

        def enrich(page)
          return unless context.model_name == 'pages'

          enricher_page = fetch_enricher_page(context)
          return if enricher_page.nil?

          enrich_layout(enricher_page, page)
          enrich_areas(enricher_page, page)
        end

        def fetch_enricher_page(context)
          repo = SoupCMS::Api::DocumentRepository.new(context)
          repo.model_name = 'pages'
          repo.with({'meta.name' => 'enricher'}).fetch_one
        end

        private

        def enrich_areas(enricher_page, page)
          enricher_page['areas'].each do |area|
            unless page['areas'].index { |a| a['name'] == area['name'] }
              page['areas'] << area
            end
          end
        end

        def enrich_layout(enricher_page, page)
          if page['layout'].nil? || page['layout'].empty?
            page.merge!({'layout' => enricher_page['layout']}) if enricher_page['layout']
          end
        end


      end


    end
  end
end