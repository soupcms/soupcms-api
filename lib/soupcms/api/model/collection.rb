module SoupCMS
  module Api

    class Collection

      DEFAULT_SORT_ON_PUBLISH_DATETIME = {publish_datetime: :desc}

      def initialize(db, collection_name)
        @db = db
        @collection_name = collection_name
        @filters = {}
        @sort = DEFAULT_SORT_ON_PUBLISH_DATETIME
        @limit = 10
      end

      def published
        @filters.merge!(state: SoupCMS::Api::Document::PUBLISHED)
        self
      end

      def latest
        @sort.merge!(DEFAULT_SORT_ON_PUBLISH_DATETIME)
        self
      end

      def limit(limit)
        @limit = limit
        self
      end

      def fetch
        coll = @db.collection(@collection_name)
        coll.find(@filters, { limit: @limit }).sort(@sort).to_a.collect { |doc| SoupCMS::Api::Document.new(doc) }
      end

    end

  end
end