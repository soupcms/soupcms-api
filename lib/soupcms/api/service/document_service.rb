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
          repo.sort({ params['sort_by'] => params['sort_order'] }) if params['sort_by']
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
              sort_hash[sort.match(/^-/).post_match] = :descending
            else
              sort_hash[sort] = :ascending
            end
          end
          sort_hash
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
