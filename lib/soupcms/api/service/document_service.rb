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
          repo.tags(params['tags'].collect { |tag| tag }) unless params['tags'].empty?
          apply_custom_field_filters
          repo.fields(params['fields']) if params['fields']
          repo.sort({ params['sort_by'] => params['sort_order'] }) if params['sort_by']
          docs = repo.fetch_all
          docs.enrich_documents(context)
          docs.resolve_dependencies(context)
          docs
        end

        def fetch_one
          repo.with(params['key'] => params['value'])
          repo.fields(params['fields']) if params['fields']
          doc = repo.fetch_one
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
          context.drafts? ? repo.drafts : repo.published
          repo.locale(params['locale'])
        end

        def apply_custom_field_filters
          params['filters'].each { |filter|
            filter_value = params[filter]
            if filter_value.kind_of?(Array)
              values = filter_value.collect { |v| eval_value(v) }
              repo.with(filter => { '$in' => values} )
            else
              repo.with(filter => eval_value(filter_value))
            end
          }
        end

        def eval_value(value)
          number?(value) || boolean?(value) || matcher?(value) ? eval(value) : value
        end

        def number?(value)
          !value.match(/^([+-]?)\d*([\.]?)\d*$/).nil?
        end

        def boolean?(value)
          value == 'true' || value == 'false'
        end

        def matcher?(value)
          !value.match(/^\/.*\/$/).nil?
        end

      end


    end
  end
end
