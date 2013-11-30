module SoupCMS
  module Api

    class Documents

      def initialize(field_to_compare = 'version')
        @field_to_compare = field_to_compare
        @docs = []
      end

      attr_accessor :docs

      def add(document)
        index = @docs.index { |doc| doc['doc_id'] == document['doc_id'] }
        if index.nil?
          @docs << document
        else
          existing_doc = @docs[index]
          if existing_doc[@field_to_compare] < document[@field_to_compare]
            @docs[index] = document
          end
        end
      end

    end

  end
end