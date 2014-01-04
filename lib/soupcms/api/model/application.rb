require 'mongo'

module SoupCMS
  module Api
    module Model

      class Application


        def initialize(name, app_base_url, mongo_uri = nil)
          @name = name
          @app_base_url = app_base_url
          @mongo_uri = (mongo_uri || "mongodb://localhost:27017/#{name}")
        end

        attr_reader :name, :app_base_url, :mongo_uri

      end


    end
  end
end
