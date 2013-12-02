require 'mongo'

module SoupCMS
  module Api

    class MongoDbConnection

      def initialize(database_name = 'test', host = 'localhost', port = '27017', options ={})
        @database_name = database_name
        @host = host
        @port = port
        @options = options
        connect
      end

      def connect
        @conn ||= Mongo::MongoClient.new(@host, @port)
        @db ||= @conn.db(@database_name)
      end

      attr_accessor :db, :conn

      def close
        @conn.close
      end

    end

  end
end