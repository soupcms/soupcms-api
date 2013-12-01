require 'grape'
require 'json'

module SoupCMS

  class API < ::Grape::API
    prefix 'api'
    format :json

    desc 'get published documents'
    get ':app_name/:model_name', requirements: { app_name: /[A-Za-z0-9\-]*/, model_name: /[A-Za-z0-9]*/ } do
      documents = SoupCMS::Api::DataService.model(params['app_name'], params['model_name']).published.fetch
      documents.collect { |doc| doc.document }
    end

  end

end