module SoupCMS
  module Api
    module Resolver

      class Base

        def resolve(document,context)
          raise 'Implement resolve method for the resolver.'
        end
      end

    end
  end
end
