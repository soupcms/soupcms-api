module SoupCMS
  module Api
    class DependencyResolver

      def initialize(context)
        @context = context
        @resolvers = SoupCMS::ModelAPI.config.dependency_resolvers
      end

      attr_reader :resolvers

      def resolve(document)
        document.each do |key, value|
          resolver = find_resolver(key)
          if resolver
            document[key] = resolver.new.resolve(value,@context)
          elsif value.kind_of?(Array)
            document[key] = value.collect { |item| item.kind_of?(Hash) ? resolve(item) : item }
          elsif value.kind_of?(Hash)
            document[key] = resolve(value)
          end
        end
        document
      end

      def find_resolver(key)
        resolver = nil
        resolvers.select { |k,v| resolver = v if key.match(k) }
        resolver
      end

    end
  end
end

