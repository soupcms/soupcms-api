require 'kramdown'
require 'nokogiri'


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
          html = Kramdown::Document.new(value['value'], options).to_html
          value['value'] = SoupCMS::Api::Resolver::Markdown::Base.apply_resolvers(html, context)
          return value, false
        end

      end

    end
  end
end
