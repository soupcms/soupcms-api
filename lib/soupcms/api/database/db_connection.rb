module SoupCMS
  module Api

    class DbConnection

      def initialize(database_name, host: 'localhost', port: '27017', **options)
        @database_name = database_name
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