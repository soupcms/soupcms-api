module SoupCMS
  module Api

    module DocumentState
      PUBLISHED = 'published'
      PUBLISHED_ARCHIVE = 'published_archive'
      DRAFT = 'draft'
      SCHEDULED = 'scheduled'
      ARCHIVE = 'archive'
    end

    module DocumentDefaults
      DEFAULT_LOCALE = 'en_US'

    end

    class Document

      def initialize doc
        @document = doc
      end

      def [](key)
        @document[key]
      end

      attr_accessor :document

    end

  end
end