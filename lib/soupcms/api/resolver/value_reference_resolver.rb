module SoupCMS
  module Api
    module Resolver


      class ValueReferenceResolver < Base

        def resolve(value, context)
          parts = value.split(':')
          return value, true unless parts[0] == 'ref'

          repo = SoupCMS::Api::DocumentRepository.new(context)
          repo.model_name = parts[1]
          context.drafts? ? repo.drafts : repo.published
          repo.with({'doc_id' => parts[2]})
          doc = repo.fetch_one
          if doc.nil? then
            return value, true
          else
            return doc.to_hash, true
          end
        end
      end

    end
  end
end
