module SoupCMS
  module Api

    class Model

      include SoupCMS::Api::DocumentState
      include SoupCMS::Api::DocumentDefaults

      DEFAULT_SORT_ON_PUBLISH_DATETIME = {'publish_datetime' => :desc}

      def initialize(db, collection_name)
        @db = db
        @collection_name = collection_name
        @filters = {}
        @duplicate_docs_compare_key = 'version'
        @sort = DEFAULT_SORT_ON_PUBLISH_DATETIME
        @limit = 10
      end

      def published
        @duplicate_docs_compare_key = 'publish_datetime'
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

      def sort(order)
        @sort = order
        self
      end

      def locale(locale)
        @filters.merge!({'locale' => locale})
        self
      end


      def fetch
        coll = @db.collection(@collection_name)
        published if @filters.empty?
        locale(DEFAULT_LOCALE) unless @filters['locale']
        docs = SoupCMS::Api::Documents.new(@duplicate_docs_compare_key)
        coll.find(@filters, { limit: @limit }).sort(@sort).each { |doc| docs.add(SoupCMS::Api::Document.new(doc)) }
        docs.documents
      end

      def get
        fetch[0]
      end

    end

  end
end