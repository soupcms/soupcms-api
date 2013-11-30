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

    end

  end
end