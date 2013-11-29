require 'mongo'

module SoupCMS
  module Api

    class MongoDbConnection < SoupCMS::Api::DbConnection

      def connect
        @conn ||= Mongo::MongoClient.new(@host, @port)
        @db ||= @conn.db(@database)
      end

      attr_accessor :db, :conn

    end

  end
end