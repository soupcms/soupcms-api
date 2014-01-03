module SoupCMS
  module Api
    module Strategy
      module Application

        class SingleApp < ApplicationStrategy

          def self.configure
            yield self
          end

          def self.app_name=(app_name)
            @@app_name = app_name
          end

          def self.app_base_url=(app_base_url)
            @@app_base_url = app_base_url
          end

          def app_name
            @@app_name
          end

          def app_base_url
            @@app_base_url
          end

          def path
            request_path[1..-1]
          end

        end

      end
    end
  end
end

