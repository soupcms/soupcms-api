require 'grape'
require 'json'

module SoupCMS

  class ModelAPI < ::Grape::API
    prefix 'api'
    format :json

    desc 'get published documents'
    params do
      optional :tags, type: Array, default: []
      optional :include, type: String, default: 'published'
    end
    get ':app_name/:model_name', requirements: { app_name: /[A-Za-z0-9\-]*/, model_name: /[A-Za-z0-9]*/ } do
      service_model = SoupCMS::Api::DataService.model(params['app_name'], params['model_name'])
      params['include'] == 'published' ? service_model.published : service_model.drafts
      service_model.tags(params['tags']) unless params['tags'].empty?
      documents = service_model.fetch_all
      documents.collect { |doc| doc.document }
    end

  end

end