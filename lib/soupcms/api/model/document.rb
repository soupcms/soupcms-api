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

      def initialize(document)
        @document = document
      end

      def [](key)
        @document[key]
      end

      def []=(key,value)
        @document[key] = value
      end

      def merge!(hash)
        @document.merge!(hash)
      end

      def to_json(*args)
        @document.to_json
      end

      def to_hash
        @document.to_hash
      end

      def resolve(context)
        SoupCMS::Api::DataResolver.new(context).resolve(self)
        self
      end

      def enrich(context)
        SoupCMSApi.config.enrichers.each { |enricher| enricher.new(context).enrich(self) }
        self
      end


    end

  end
end