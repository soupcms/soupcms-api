module SoupCMS
  module Api

    class Document

      PUBLISHED = 'published'
      DRAFT = 'draft'
      SCHEDULED = 'scheduled'
      ARCHIVE = 'archive'

      def initialize doc
        @doc = doc
      end

    end

  end
end