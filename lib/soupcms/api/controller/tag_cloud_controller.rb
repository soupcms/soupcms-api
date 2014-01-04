module SoupCMS
  module Api
    module Controller


      class TagCloudController < SoupCMS::Common::Controller::BaseController

        def execute
          service = SoupCMS::Api::Service::DocumentService.new(context)
          service.tag_cloud || []
        end

      end


    end
  end
end