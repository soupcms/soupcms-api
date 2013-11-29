module SoupCMS
  module Api

    class Collection

      def initialize(db, collection_name)
        @db = db
        @collection_name = collection_name
        @filters = {}
        @sort = {publish_date: :desc}
        @limit = 10
      end

      def published
        @filters.merge!(state: SoupCMS::Api::Document::PUBLISHED)
        self
      end

      def latest
        @sort.merge!(publish_datetime: :desc)
        self
      end

      def fetch
        coll = @db.collection(@collection_name)
        coll.find(@filters).to_a.collect { |doc| SoupCMS::Api::Document.new(doc) }
      end

    end

  end
end