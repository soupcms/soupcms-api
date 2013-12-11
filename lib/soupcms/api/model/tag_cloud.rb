module SoupCMS
  module Api

    class TagCloud < SoupCMS::Api::Documents

      def initialize
        @documents = []
      end

      attr_accessor :documents

      def add(document)
        @documents << document
      end

      def to_json(*args)
        documents.collect { |doc| doc.document }.to_json
      end


    end

  end
end