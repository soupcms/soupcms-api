module SoupCMS
  module Api

    module Utils

      module ConfigDefaults
        DEPENDENCY_RESOLVERS = {
            /link$/ => SoupCMS::Api::Resolver::LinkResolver,
            'tags' => SoupCMS::Api::Resolver::TagResolver,
            /content$/ => SoupCMS::Api::Resolver::MarkdownResolver
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
        end

        attr_reader :dependency_resolvers, :enrichers

        def register_dependency_resolver(key, resolver)
          @dependency_resolvers[key] = resolver
        end

        def register_enricher(enricher)
          @enrichers << enricher
        end

        def clear_enricher
          @enrichers = []
        end




      end

    end
  end
end
