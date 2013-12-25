module SoupCMS
  module Api

    module Utils

      class Config

        def initialize
          @enrichers = [
              SoupCMS::Api::Enricher::PageEnricher,
              SoupCMS::Api::Enricher::UrlEnricher
          ]
          @http_caching_strategy = SoupCMS::Api::Utils::HttpCacheStrategy
        end

        attr_accessor :http_caching_strategy, :enrichers

        def register_dependency_resolver(key, resolver)
          SoupCMS::Api::DependencyResolver.register_dependency_resolver key, resolver
        end

        def clear_dependency_resolvers
          SoupCMS::Api::DependencyResolver.clear_dependency_resolvers
        end

        def register_enricher(enricher, prepend = false)
          prepend ? @enrichers.unshift(enricher) : @enrichers << enricher
        end

        def clear_enrichers
          @enrichers = []
        end




      end

    end
  end
end
