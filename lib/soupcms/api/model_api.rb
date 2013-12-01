require 'grape'
require 'json'

module SoupCMS

  class ModelAPI < ::Grape::API
    prefix 'api'
    format :json

    helpers do

      def get_service_model
        service_model = SoupCMS::Api::DataService.model(params['app_name'], params['model_name'])
        params['include'] == 'published' ? service_model.published : service_model.drafts
        service_model
      end
    end


    group ':app_name' do
      params do
        optional :include, type: String, default: 'published'
      end
      group ':model_name' do

        desc 'get published documents'
        params do
          optional :tags, type: Array, default: []
        end
        get do
          service_model = get_service_model
          service_model.tags(params['tags']) unless params['tags'].empty?
          documents = service_model.fetch_all
          documents.collect { |doc| doc.document }
        end


        desc 'get a document'
        get ':doc_id' do
          service_model = get_service_model
          doc = service_model.doc_id(params['doc_id']).fetch_one
          error!("Document #{params['doc_id']} not found.", 404) if doc.nil?
          doc.document
        end


      end
    end




  end

end