module SoupCMS
  module Api

    module Utils

      module ConfigDefaults
        DEPENDENCY_RESOLVERS = {
            /ref$/ => SoupCMS::Api::Resolver::ReferenceResolver,
            'tags' => SoupCMS::Api::Resolver::TagResolver,
            /content$/ => SoupCMS::Api::Resolver::MarkdownResolver,
            /link$/ => SoupCMS::Api::Resolver::LinkResolver
        }
        ENRICHERS = [
            SoupCMS::Api::Enricher::PageEnricher,
            SoupCMS::Api::Enricher::UrlEnricher
        ]
      end

      class Config

        def initialize
          @dependency_resolvers = ConfigDefaults::DEPENDENCY_RESOLVERS
          @enrichers = ConfigDefaults::ENRICHERS
          @http_caching_strategy = SoupCMS::Api::Utils::HttpCacheStrategy
        end

        attr_accessor :http_caching_strategy
        attr_reader :dependency_resolvers, :enrichers

        def register_dependency_resolver(key, resolver)
          @dependency_resolvers[key] = resolver
        end

        def clear_dependency_resolvers
          @dependency_resolvers = {}
        end

        def register_enricher(enricher)
          @enrichers << enricher
        end

        def clear_enrichers
          @enrichers = []
        end




      end

    end
  end
end
