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
          if resolvers[key]
            document[key] = resolvers[key].new.resolve(value,@context)
          elsif value.kind_of?(Array)
            document[key] = value.collect { |item| item.kind_of?(Hash) ? resolve(item) : item }
          elsif value.kind_of?(Hash)
            document[key] = resolve(value)
          end
        end
        document
      end

    end
  end
end

