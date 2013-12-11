require 'bson'

module SoupCMS
  module Api

    class DocumentRepository

      include SoupCMS::Api::DocumentState
      include SoupCMS::Api::DocumentDefaults

      DEFAULT_SORT_ON_PUBLISH_DATETIME = {'publish_datetime' => :desc}

      def initialize(db, context)
        @db = db
        @context = context
        @filters = {}
        @duplicate_docs_compare_key = 'version'
        @sort = DEFAULT_SORT_ON_PUBLISH_DATETIME
        @limit = 10
      end

      def collection
        @db.collection(@context.model_name)
      end

      def published
        @duplicate_docs_compare_key = 'publish_datetime'
        @filters.delete('latest') # remove if latest filter added, conflicting filters
        @filters.merge!('state' => PUBLISHED)
        self
      end

      def drafts
        @sort = {'create_datetime' => :desc}

        @filters.delete('state') # remove if state added in filters, conflicting filters
        @filters.merge!({'latest' => true})
        self
      end

      def limit(limit)
        @limit = limit
        self
      end

      def tags(*tags)
        tags.flatten!
        @filters.merge!({'tags' => {'$in' => tags}})
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


      def fetch_all
        published if @filters.empty?
        locale(DEFAULT_LOCALE) unless @filters['locale']
        docs = SoupCMS::Api::Documents.new(@duplicate_docs_compare_key)
        collection.find(@filters, {limit: @limit}).sort(@sort).each { |doc| docs.add(SoupCMS::Api::Document.new(doc)) }
        docs.documents
      end

      def fetch_one
        fetch_all[0]
      end

      TAG_CLOUD_MAP_FUNCTION = BSON::Code.new <<-map_function
          function() {
              if (!this.tags) {
                  return;
              }

              for (index in this.tags) {
                  emit(this.tags[index], 1);
              }
          };
      map_function

      TAG_CLOUD_REDUCE_FUNCTION = BSON::Code.new <<-reduce_function
          function(previous, current) {
              var count = 0;

              for (index in current) {
                  count += current[index];
              }

              return count;
          };
      reduce_function

      def tag_cloud

        result = collection.map_reduce(TAG_CLOUD_MAP_FUNCTION, TAG_CLOUD_REDUCE_FUNCTION, {out: {inline: true}, raw: true, filters: @filters})

        tags = {'tags' => []}
        result['results'].each do |tag|
          tag_result = {}
          tag_result['label'] = tag['_id']
          tag_result['weight'] = Integer(tag['value'])
          tag_result['link'] = { 'model_name' => 'posts', 'match' => { 'tags' => tag['_id'] } }
          tags['tags'] << tag_result
        end

        tags
      end

    end

  end
end