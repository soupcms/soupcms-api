module SoupCMS
  module Api
    module Strategy
      module Application

        class ApplicationStrategy

          def initialize(request)
            @request = request
          end

          attr_reader :request

          def app_name
            raise 'Implement method app_name'
          end

          def app_base_url
            raise 'Implement method app base url'
          end

          def path
            raise 'Implement method path'
          end

          def not_found_message
            "Page '#{path}' not found in application '#{app_name}'"
          end

          def request_path
            request.path.gsub('/api/','/')
          end


          def application
            @@apps ||= {}
            if @@apps[app_name].nil?
              @@apps[app_name] = SoupCMS::Api::Model::Application.new(app_name, app_base_url)
            end
            @@apps[app_name]
          end

          def self.apps=(apps = {})
            @@apps = apps
          end

        end

      end
    end
  end
end

