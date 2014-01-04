module SoupCMS
  module Api
    module Controller


      class ModelController < SoupCMS::Common::Controller::BaseController

        def execute
          service = SoupCMS::Api::Service::DocumentService.new(context)
          service.fetch_all || []
        end

      end


    end
  end
end