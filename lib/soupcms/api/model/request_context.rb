module SoupCMS
  module Api
    module Model

      class RequestContext

        def initialize(application, params = {})
          @application = application
          @params = params
        end

        attr_reader :application, :params

        def user_params
          @params.to_hash.delete('route_info')
        end

        def model_name
          params['model_name']
        end

        def drafts?
          params['include'] == 'drafts'
        end

        def environment
          ENV['RACK_ENV'] || 'test'
        end
      end

    end
  end
end

