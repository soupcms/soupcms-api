require 'kramdown'


module SoupCMS
  module Api
    module Resolver

      class KramdownMarkdownResolver < Base

        def resolve(value, context)
          return value, true if value['type'] != 'markdown' || value['flavor'] != 'kramdown'
          value['value'] = Kramdown::Document.new(value['value']).to_html
          return value, false
        end

      end

    end
  end
end
