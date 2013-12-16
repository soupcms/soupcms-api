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

      def service
        SoupCMS::Api::Service::DocumentService.new(context)
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
          service.tag_cloud
        end

        desc 'get published documents'
        params do
          optional :tags, type: Array, default: []
          optional :filters, type: Array, default: []
          optional :sort_order, type: String, default: :ascending
        end
        get do
          service.fetch_all
        end

        desc 'get a document by key'
        get ':key/:value' do
          doc = service.fetch_one
          error!("Document #{params['value']} not found.", 404) if doc.nil?
          doc
        end

      end
    end

end