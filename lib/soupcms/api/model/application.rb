require 'mongo'

module SoupCMS
  module Api
    module Model

      class Application


        def initialize(name)
          @name = name
        end

        attr_writer :mongo_uri
        attr_reader :name

        def mongo_uri
          @mongo_uri || "mongodb://localhost:27017/#{name}"
        end

        def connection
          Mongo::MongoClient.from_uri(mongo_uri)
        end

        def self.get(name)
          @@apps ||= {}
          if @@apps[name].nil?
            @@apps[name] = Application.new(name)
          end
          @@apps[name]
        end

      end


    end
  end
end
