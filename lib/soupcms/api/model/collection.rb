module SoupCMS
  module Api

    class Collection

      def initialize(database, collection_name)
        @database = database
        @collection_name = collection_name
        @filters = {}
        @sort = {publish_date: :desc}
        @limit = 10
      end

      def published
        @filters.merge!(state: 'published')
      end

      def latest
        @sort.merge!(publish_datetime: :desc)
      end

      def fetch
        coll = @database.collection(@collection_name)
        coll.find.to_a.collect { |doc| SoupCMS::Api::Document.new(doc) }
      end

    end

  end
end