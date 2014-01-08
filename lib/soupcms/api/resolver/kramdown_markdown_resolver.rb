require 'kramdown'


module SoupCMS
  module Api
    module Resolver

      class KramdownMarkdownResolver < Base

        def self.options=(options)
          @@options = options
        end

        def options
          @@options ||= {}
        end

        def resolve(value, context)
          return value, true if value['type'] != 'markdown' || value['flavor'] != 'kramdown'
          value['value'] = Kramdown::Document.new(value['value'], options).to_html
          return value, false
        end

      end

    end
  end
end
