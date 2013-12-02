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

      def apply_custom_field_filters(service_model)
        params['filters'].each { |filter|
          filter_value = params[filter]
          #TODO eval are security risk, scope it if possible
          if filter_value.kind_of?(Array)
            values = filter_value.collect { |v| eval(v) }
            service_model.with(filter => { '$in' => values} )
          else
            service_model.with(filter => eval(filter_value))
          end
        }
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
          optional :filters, type: Array, default: []
          optional :sort_order, type: String, default: :ascending
        end
        get do
          service_model = get_service_model
          service_model.tags(params['tags']) unless params['tags'].empty?

          apply_custom_field_filters(service_model)

          service_model.sort({ params['sort_by'] => params['sort_order'] }) if params['sort_by']

          documents = service_model.fetch_all
          documents.collect { |doc| doc.document }
        end


        desc 'get a document by key'
        get ':key/:value' do
          service_model = get_service_model
          doc = service_model.with(params['key'] => params['value']).fetch_one
          error!("Document #{params['value']} not found.", 404) if doc.nil?
          doc.document
        end


      end
    end




  end

end