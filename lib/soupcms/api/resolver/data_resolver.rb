module SoupCMS
  module Api
    class DataResolver

      def self.register(key, resolver)
        resolvers[key] = resolver
      end

      def self.clear_all
        @@resolvers = {}
      end

      def self.resolvers
        @@resolvers ||= {
            /ref$/ => SoupCMS::Api::Resolver::ReferenceResolver,
            'tags' => SoupCMS::Api::Resolver::TagResolver,
            /content$/ => SoupCMS::Api::Resolver::MarkdownResolver,
            /link$/ => SoupCMS::Api::Resolver::LinkResolver
        }
      end


      def initialize(context)
        @context = context
      end

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

      private

      @@key_resolvers = {}  # key and its resolvers are cached
      def find_resolver(key)
        if @@key_resolvers[key].nil?
          @@key_resolvers[key] = self.class.resolvers.select { |k, v| key.match(k) }.values.compact[0]
        end
        @@key_resolvers[key]
      end

    end
  end
end

