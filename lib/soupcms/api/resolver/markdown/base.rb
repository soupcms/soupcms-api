module SoupCMS
  module Api
    module Resolver
      module Markdown

        class Base

          def self.register(resolver)
            resolvers.push(resolver)
          end

          def self.clear_all
            @@resolvers = []
          end

          def self.resolvers
            @@resolvers ||= [
                SoupCMS::Api::Resolver::Markdown::ImageRef,
                SoupCMS::Api::Resolver::Markdown::LinkRef
            ]
          end

          def self.apply_resolvers(html, context)
            resolvers.each { |resolver| html = resolver.new(context).resolve(html) }
            html
          end


          def initialize(context)
            @context = context
          end

          attr_reader :context

          def resolve(document)
            raise 'Implement resolve method for the resolver.'
          end
        end

      end
    end
  end
end
