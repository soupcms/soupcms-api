module SoupCMS
  module Api
    module Controller


      class KeyValueController

        def execute(context)
          service = SoupCMS::Api::Service::DocumentService.new(context)
          service.fetch_one
        end

      end


    end
  end
end