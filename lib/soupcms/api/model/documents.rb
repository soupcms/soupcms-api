module SoupCMS
  module Api

    class Documents

      def initialize(field_to_compare = 'version')
        @field_to_compare = field_to_compare
        @documents = []
      end

      attr_accessor :documents

      def add(document)
        index = @documents.index { |doc| doc['doc_id'] == document['doc_id'] }
        if index.nil?
          @documents << document
        else
          existing_doc = @documents[index]
          if existing_doc[@field_to_compare] < document[@field_to_compare]
            @documents[index] = document
          end
        end
      end

      def to_json(*args)
        documents.collect { |doc| doc.to_hash }.to_json
      end

      def size
        @documents.size
      end

      def [](index)
        @documents[index]
      end

      def resolve(context)
        documents.each { |doc| doc.resolve(context) }
        self
      end

      def enrich(context)
        documents.each { |doc| doc.enrich(context)  }
        self
      end

    end

  end
end