module SoupCMS
  module Api
    module Strategy
      module Application

        class UrlBased < ApplicationStrategy

          def initialize(request)
            @request = request
          end

          attr_reader :request

          def app_name
            url_parser = request_path.match(/\/[\w\.\-]*\//)
            url_parser[0].gsub('/', '') if url_parser
          end

          def path
            url_parser = request_path.match(/\/[\w\.\-]*\//)
            url_parser.post_match if url_parser
          end

          def app_base_url
            "#{request.base_url}/#{app_name}"
          end


        end

      end
    end
  end
end

