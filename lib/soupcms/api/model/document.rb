module SoupCMS
  module Api

    class Document

      PUBLISHED = 'published'
      PUBLISHED_ARCHIVE = 'published_archive'
      DRAFT = 'draft'
      SCHEDULED = 'scheduled'
      ARCHIVE = 'archive'

      VALID_STATES = [PUBLISHED, DRAFT, SCHEDULED]


      def initialize doc
        @doc = doc
      end

      def [](key)
        @doc[key]
      end

    end

  end
end