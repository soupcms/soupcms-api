module SoupCMS
  module Api
    class DataService

      def self.model(application_name, collection_name)
        db = SoupCMS::Api::MongoDbConnection.new(application_name).db
        SoupCMS::Api::Collection.new(db,collection_name)
      end

    end
  end
end