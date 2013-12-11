require 'grape'
require 'json'

class SoupCMSApi < Grape::API
    prefix 'api'
    format :json

    def self.config
      @@config ||= SoupCMS::Api::Utils::Config.new
    end

    helpers do

      def context
        application = SoupCMS::Api::Model::Application.get(params['app_name'])
        SoupCMS::Api::Model::RequestContext.new(application, params)
      end

      def get_service_model
        service_model = SoupCMS::Api::DocumentRepository.new(context)
        params['include'] == 'published' ? service_model.published : service_model.drafts
        service_model.locale(params['locale'])
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
        optional :locale, type: String, default: 'en_US'
      end
      group ':model_name' do

        desc 'get a tag cloud'
        get 'tag-cloud' do
          service_model = get_service_model
          service_model.tag_cloud
        end

        desc 'get published documents'
        params do
          optional :tags, type: Array, default: []
          optional :filters, type: Array, default: []
          optional :sort_order, type: String, default: :ascending
        end
        get do
          service_model = get_service_model
          service_model.tags(params['tags'].collect { |tag| eval(tag)}) unless params['tags'].empty?

          apply_custom_field_filters(service_model)

          service_model.sort({ params['sort_by'] => params['sort_order'] }) if params['sort_by']

          service_model.fetch_all
        end

        desc 'get a document by key'
        get ':key/:value' do
          service_model = get_service_model
          doc = service_model.with(params['key'] => params['value']).fetch_one
          error!("Document #{params['value']} not found.", 404) if doc.nil?
          doc
        end

      end
    end

end