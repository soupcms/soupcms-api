module SoupCMS
  module Api
    module Strategy
      module Application

        class SubDomainBased < ApplicationStrategy

          def app_name
            request.host.match(/^[\w\-]*\./)[0].gsub('.','')
          end

          def path
            request_path[1..-1]
          end

          def app_base_url
            "#{request.base_url}"
          end

        end

      end
    end
  end
end

