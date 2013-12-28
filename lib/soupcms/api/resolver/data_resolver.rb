module SoupCMS
  module Api
    class DataResolver

      def self.register(key, resolver)
        resolvers.push({key: key, resolver: resolver})
      end

      def self.clear_all
        @@resolvers = []
      end

      def self.resolvers
        @@resolvers ||= [
            {key: /ref$/, resolver: SoupCMS::Api::Resolver::ReferenceResolver},
            {key: 'tags', resolver: SoupCMS::Api::Resolver::TagResolver},
            {key: /link$/, resolver: SoupCMS::Api::Resolver::LinkResolver}
        ]
      end


      def initialize(context)
        @context = context
      end

      def resolve(doc)
        resolve_dependency_recursive(doc.to_hash)
      end

      def resolve_dependency_recursive(document)
        document.each do |key, value|
          resolvers = find_resolver(key)
          continue = true
          if !resolvers.empty?
            resolvers.each do |resolver|
              value, continue = resolver.new.resolve(value, @context)
              document[key] = value
              break unless continue
            end
            next unless continue
          end
          if value.kind_of?(Array)
            document[key] = value.collect { |item| item.kind_of?(Hash) ? resolve_dependency_recursive(item) : item }
          elsif value.kind_of?(Hash)
            document[key] = resolve_dependency_recursive(value)
          end
        end
      end

      private

      @@key_resolvers = {} # key and its resolvers are cached
      def find_resolver(key)
        if @@key_resolvers[key].nil?
          @@key_resolvers[key] = self.class.resolvers.collect { |kv| kv[:resolver] if key.match(kv[:key]) }.compact
        end
        @@key_resolvers[key]
      end

    end
  end
end

