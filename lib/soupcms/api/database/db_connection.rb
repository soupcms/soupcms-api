module SoupCMS
  module Api

    class DbConnection

      def initialize(database, host: 'localhost', port: '27017', **options)
        @database = database
        @host = host
        @port = port
        @options = options
        connect
      end

      def connect
        raise 'to be implemented by each subclass'
      end

    end

  end
end