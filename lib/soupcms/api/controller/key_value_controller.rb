module SoupCMS
  module Api
    module Controller


      class KeyValueController < SoupCMS::Common::Controller::BaseController

        def execute
          service = SoupCMS::Api::Service::DocumentService.new(context)
          service.fetch_one
        end

      end


    end
  end
end