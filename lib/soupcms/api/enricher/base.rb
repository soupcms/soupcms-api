module SoupCMS
  module Api
    module Enricher



      class Base

        def initialize(context)
          @context = context
        end

        attr_reader :context

        def enrich(document,context)
          raise 'Implement enrich method for the enricher.'
        end


      end




    end
  end
end