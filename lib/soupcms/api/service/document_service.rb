module SoupCMS
  module Api
    module Service


      class DocumentService

        def initialize(context)
          @context = context
          @params = context.params
        end

        attr_reader :context, :params, :repo

        def repo
          @repo ||= SoupCMS::Api::DocumentRepository.new(context)
        end

        def fetch_all
          apply_common_filters
          docs = repo.fetch_all
          docs.enrich(context).resolve(context) if docs
        end

        def fetch_one
          apply_common_filters
          doc = repo.fetch_one
          doc.enrich(context).resolve(context) if doc
        end

        def tag_cloud
          repo.tag_cloud.resolve(context)
        end

        private
        def apply_common_filters
          context.drafts? ? repo.drafts : repo.published
          apply_custom_field_filters
          repo.locale(params['locale']) if params['locale']
          repo.fields(params['fields']) if params['fields']
          repo.limit(params['limit'].to_i) if params['limit']
          repo.sort(sort_to_hash(params['sort'])) if params['sort']
        end

        def sort_to_hash(sorts = [])
          sorts = sorts || []
          sort_hash = {}
          sorts.each do |sort|
            if sort.match(/^-/)
              sort_hash[sort.gsub('-','').strip] = -1
            else
              sort_hash[sort.gsub('+','').strip] = 1
            end
          end
          sort_hash
        end

        def apply_custom_field_filters
          filters = params['filters'] || []
          filters.each { |filter|
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
