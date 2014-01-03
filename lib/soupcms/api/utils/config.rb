module SoupCMS
  module Api

    module Utils

      class Config

        def application_strategy
          @application_strategy ||= SoupCMS::Api::Strategy::Application::UrlBased
        end

        def application_strategy=(strategy)
          @application_strategy = strategy
        end

        def http_caching_strategy
          @http_caching_strategy ||= SoupCMS::Api::Utils::HttpCacheStrategy
        end

        def http_caching_strategy=(caching_strategy)
          @http_caching_strategy = caching_strategy
        end

        def data_resolver
          SoupCMS::Api::DataResolver
        end

        def enrichers
          @enrichers ||= [
              SoupCMS::Api::Enricher::PageEnricher,
              SoupCMS::Api::Enricher::UrlEnricher
          ]
        end

        def register_enricher(enricher, prepend = false)
          prepend ? enrichers.unshift(enricher) : enrichers.push(enricher)
        end

        def clear_enrichers
          @enrichers = []
        end




      end

    end
  end
end
