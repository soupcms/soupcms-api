module SoupCMS
  module Api

    module Utils

      module ConfigDefaults
        DEPENDENCY_RESOLVER = {
            'link' => SoupCMS::Api::Resolver::LinkResolver
        }
      end

      class Config

        def initialize
          @dependency_resolvers = ConfigDefaults::DEPENDENCY_RESOLVER
        end

        attr_reader :dependency_resolvers

        def register_dependency_resolver(key, resolver)
          @dependency_resolvers[key] = resolver
        end





      end

    end
  end
end
