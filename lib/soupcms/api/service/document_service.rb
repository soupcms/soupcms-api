module SoupCMS
  module Api
    module Service


      class DocumentService

        def initialize(context)
          @context = context
          @params = context.params
          @repo = SoupCMS::Api::DocumentRepository.new(context)
          apply_common_filters
        end

        attr_reader :context, :params, :repo

        def fetch_all
          repo.tags(params['tags'].collect { |tag| eval(tag)}) unless params['tags'].empty?
          apply_custom_field_filters
          repo.sort({ params['sort_by'] => params['sort_order'] }) if params['sort_by']
          repo.fetch_all
        end

        def fetch_one
          repo.with(params['key'] => params['value']).fetch_one
        end

        def tag_cloud
          repo.tag_cloud
        end

        private
        def apply_common_filters
          params['include'] == 'published' ? repo.published : repo.drafts
          repo.locale(params['locale'])
        end

        def apply_custom_field_filters
          params['filters'].each { |filter|
            filter_value = params[filter]
            #TODO eval are security risk, scope it if possible
            if filter_value.kind_of?(Array)
              values = filter_value.collect { |v| eval(v) }
              repo.with(filter => { '$in' => values} )
            else
              repo.with(filter => eval(filter_value))
            end
          }
        end

      end


    end
  end
end
