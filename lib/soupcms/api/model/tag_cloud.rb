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


    end




  end
end