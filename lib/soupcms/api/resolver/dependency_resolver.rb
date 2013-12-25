module SoupCMS
  module Api
    class DependencyResolver

      def initialize(context)
        @context = context
        @resolvers = SoupCMS::Api::Utils::Config.configs.dependency_resolvers
      end

      attr_reader :resolvers

      def resolve(doc)
        resolve_dependency_recursive(doc.to_hash)
      end

      def resolve_dependency_recursive(document)
        document.each do |key, value|
          resolver = find_resolver(key)
          if resolver
            value, continue = resolver.new.resolve(value,@context)
            document[key] = value
            next unless continue
          end
          if value.kind_of?(Array)
            document[key] = value.collect { |item| item.kind_of?(Hash) ? resolve_dependency_recursive(item) : item }
          elsif value.kind_of?(Hash)
            document[key] = resolve_dependency_recursive(value)
          end
        end
      end

      def find_resolver(key)
        resolver = nil
        resolvers.select { |k,v| resolver = v if key.match(k) }
        resolver
      end

    end
  end
end

