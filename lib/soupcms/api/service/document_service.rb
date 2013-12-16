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
          docs = repo.fetch_all
          docs.enrich_documents(context)
          docs.resolve_dependencies(context)
          docs
        end

        def fetch_one
          doc = repo.with(params['key'] => params['value']).fetch_one
          if doc
            doc.enrich_document(context)
            doc.resolve_dependencies(context)
          end
          doc
        end

        def tag_cloud
          docs = repo.tag_cloud
          docs.resolve_dependencies(context)
          docs
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
