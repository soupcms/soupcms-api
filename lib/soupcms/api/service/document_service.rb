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
          repo.fetch_all.enrich(context).resolve(context)
        end

        def fetch_one
          repo.with(params['key'] => params['value'])
          doc = repo.fetch_one
          doc.enrich(context).resolve(context) if doc
        end

        def tag_cloud
          repo.tag_cloud.resolve(context)
        end

        private
        def apply_common_filters
          context.drafts? ? repo.drafts : repo.published
          repo.locale(params['locale']) if params['locale']
          repo.fields(params['fields']) if params['fields']
          repo.limit(params['limit'].to_i) if params['limit']
          repo.sort(sort_to_hash(params['sort'])) if params['sort']
        end

        def sort_to_hash(sorts = [])
          sort_hash = {}
          sorts.each do |sort|
            if sort.match(/^-/)
              sort_hash[sort.gsub('-','').strip] = :descending
            else
              puts sort
              sort_hash[sort.gsub('+','').strip] = :ascending
            end
          end
          sort_hash
        end

        def apply_custom_field_filters
          params['filters'].each { |filter|
            filter_value = params[filter]
            if filter_value.kind_of?(Array)
              values = filter_value.collect { |v| SoupCMS::Common::Util::EvalValue.new(v).eval_value }
              repo.with(filter => { '$in' => values} )
            else
              repo.with(filter => SoupCMS::Common::Util::EvalValue.new(filter_value).eval_value )
            end
          }
        end

      end


    end
  end
end
