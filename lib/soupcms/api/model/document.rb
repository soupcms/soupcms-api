module SoupCMS
  module Api

    module DocumentState
      PUBLISHED = 'published'
      PUBLISHED_ARCHIVE = 'published_archive'
      DRAFT = 'draft'
      SCHEDULED = 'scheduled'
      ARCHIVE = 'archive'
    end

    class Document

      def initialize doc
        @doc = doc
      end

      def [](key)
        @doc[key]
      end

    end

  end
end