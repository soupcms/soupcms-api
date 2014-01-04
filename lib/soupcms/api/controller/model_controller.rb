module SoupCMS
  module Api
    module Controller


      class ModelController

        def execute(context)
          service = SoupCMS::Api::Service::DocumentService.new(context)
          service.fetch_all || []
        end

      end


    end
  end
end