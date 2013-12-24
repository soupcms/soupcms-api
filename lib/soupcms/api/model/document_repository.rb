require 'bson'

module SoupCMS
  module Api

    class DocumentRepository

      include SoupCMS::Api::DocumentState
      include SoupCMS::Api::DocumentDefaults

      DEFAULT_SORT_ON_PUBLISH_DATETIME = {'publish_datetime' => :desc}

      def initialize(context)
        @context = context
        @filters = {}
        @fields = []
        @duplicate_docs_compare_key = 'version'
        @sort = DEFAULT_SORT_ON_PUBLISH_DATETIME
        @limit = 10
        published
      end

      attr_reader :context
      attr_writer :model_name

      def collection
        @collection ||= context.application.connection.db.collection(model_name)
      end

      def model_name
        @model_name || context.model_name
      end

      def published
        @duplicate_docs_compare_key = 'publish_datetime'
        @filters.delete('latest') # remove if latest filter added, conflicting filters
        @filters.merge!('state' => PUBLISHED)
        @sort = DEFAULT_SORT_ON_PUBLISH_DATETIME
        self
      end

      def drafts
        @sort = {'create_datetime' => :desc}
        @duplicate_docs_compare_key = 'create_datetime'
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

      def fields(*fields)
        @fields.concat fields.flatten
        self
      end


      def fetch_all
        published if @filters.empty?
        locale(DEFAULT_LOCALE) unless @filters['locale']
        docs = SoupCMS::Api::Documents.new(@duplicate_docs_compare_key)
        options = {limit: @limit}
        options[:fields] = @fields.concat(['doc_id',@duplicate_docs_compare_key]).uniq unless @fields.empty?
        collection.find(@filters, options).sort(@sort).each do |doc|
          doc = SoupCMS::Api::Document.new(doc)
          docs.add(doc)
        end
        docs
      end

      def fetch_one
        fetch_all.documents[0]
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

        docs = SoupCMS::Api::TagCloud.new
        result['results'].each do |tag|
          tag_result = {}
          tag_result['label'] = tag['_id']
          tag_result['weight'] = Integer(tag['value'])
          tag_result['link'] = {'model_name' => 'posts', 'match' => {'tags' => tag['_id']}}
          document = SoupCMS::Api::Document.new(tag_result)
          docs.add(document)
        end
        docs
      end

    end

  end
end