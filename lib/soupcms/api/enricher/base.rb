module SoupCMS
  module Api
    module Enricher



      class Base

        def enrich(document,context)
          raise 'Implement enrich method for the enricher.'
        end


      end




    end
  end
end