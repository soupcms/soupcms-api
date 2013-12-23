module SoupCMS
  module Api
    module Resolver


      class ReferenceResolver < Base

        def resolve(value,context)
          return value, true if value['model'].nil? || value['match'].nil?
          repo = SoupCMS::Api::DocumentRepository.new(context)
          repo.model_name = value['model']
          context.drafts? ? repo.drafts : repo.published
          repo.with(value['match'])
          doc = repo.fetch_one
          return doc.to_hash, true
        end
      end

    end
  end
end
