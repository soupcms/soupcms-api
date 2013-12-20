require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'


module SoupCMS
  module Api
    module Resolver

      class RougeHTML < Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet # yep, that's it.
      end

      class MarkdownResolver < Base

        def resolve(value,context)
          markdown = Redcarpet::Markdown.new(RougeHTML, fenced_code_blocks: true, space_after_headers: true, tables: true)
          markdown.render value
        end

      end

    end
  end
end
