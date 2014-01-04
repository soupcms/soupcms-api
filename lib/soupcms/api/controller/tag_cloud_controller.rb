module SoupCMS
  module Api
    module Controller


      class TagCloudController

        def execute(context)
          service = SoupCMS::Api::Service::DocumentService.new(context)
          service.tag_cloud || []
        end

      end


    end
  end
end