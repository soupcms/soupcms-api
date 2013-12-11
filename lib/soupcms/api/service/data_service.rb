module SoupCMS
  module Api
    class DataService

      def self.model(context)
        db = SoupCMS::Api::MongoDbConnection.new(context.application).db
        SoupCMS::Api::DocumentRepository.new(db,context)
      end

    end
  end
end