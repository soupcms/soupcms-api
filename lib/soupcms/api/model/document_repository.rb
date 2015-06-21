require 'bson'
require 'mongo'

module SoupCMS
  module Api

    class DocumentRepository

      include SoupCMS::Api::DocumentState
      include SoupCMS::Api::DocumentDefaults

      DEFAULT_SORT_ON_PUBLISH_DATETIME = {'publish_datetime' => -1}
      @@database_connections = {}

      def self.database_connection(mongo_uri)
        if @@database_connections[mongo_uri].nil?
          @@database_connections[mongo_uri] = Mongo::Client.new(mongo_uri)
        end
        @@database_connections[mongo_uri].database
      end

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
        return @collection if @collection
        @collection ||= SoupCMS::Api::DocumentRepository.database_connection(context.application.mongo_uri)[model_name]
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
        @sort = {'create_datetime' => -1}
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
        projection = @fields.concat(['doc_id',@duplicate_docs_compare_key]).uniq unless @fields.empty?
        view = collection.find(@filters)
        view = view.projection(Hash[projection.collect {|f| [f,1] }]) if projection
        view = view.sort(@sort) if @sort
        view = view.limit(@limit) if @limit
        view.each do |doc|
          doc = SoupCMS::Api::Document.new(doc)
          doc['model_name'] = @model_name
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

        #result = collection.map_reduce(TAG_CLOUD_MAP_FUNCTION, TAG_CLOUD_REDUCE_FUNCTION, {out: {inline: true}, raw: true, query: @filters})

        map_reduce = Mongo::Collection::View::MapReduce.new(collection.find(@filters),TAG_CLOUD_MAP_FUNCTION,TAG_CLOUD_REDUCE_FUNCTION)
        map_reduce.out(inline: 1)    

        docs = SoupCMS::Api::TagCloud.new
        map_reduce.each do |tag|
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