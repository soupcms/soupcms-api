require 'mongo'

module SoupCMS
  module Api

    class MongoDbConnection

      def initialize(application)
        @application = application
        @conn = Mongo::MongoClient.from_uri(@application.mongo_uri)
      end

      attr_accessor :db, :conn

      def db
        conn.db
      end

      def close
        @conn.close
      end

    end

  end
end