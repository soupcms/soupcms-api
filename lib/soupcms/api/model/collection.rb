module SoupCMS
  module Api

    class Collection

      include SoupCMS::Api::DocumentState

      DEFAULT_SORT_ON_PUBLISH_DATETIME = {'publish_datetime' => :desc}

      def initialize(db, collection_name)
        @db = db
        @collection_name = collection_name
        @filters = {}
        @sort = DEFAULT_SORT_ON_PUBLISH_DATETIME
        @limit = 10
      end

      def published
        @filters.merge!('state' => PUBLISHED)
        self
      end

      def draft
        @sort = {'create_datetime' => :desc}
        @filters.merge!({'latest' => true})
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

      def tags(*tags)
        @filters.merge!({'tags' => { '$in' => tags }})
        self
      end

      def with(filters)
        @filters.merge!(filters)
        self
      end

      def doc_id(doc_id)
        @filters.merge!('doc_id' => doc_id)
        self
      end

      def fetch
        coll = @db.collection(@collection_name)
        published if @filters.empty?
        coll.find(@filters, { limit: @limit }).sort(@sort).to_a.collect { |doc| SoupCMS::Api::Document.new(doc) }
      end

      def get
        fetch[0]
      end

    end

  end
end