require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'


module SoupCMS
  module Api
    module Resolver

      class RougeHTML < Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet
      end

      class MarkdownResolver < Base

        def resolve(value, context)
          return value if value['type'] != 'markdown'
          markdown = Redcarpet::Markdown.new(RougeHTML, fenced_code_blocks: true, tables: true, autolink: true, strikethrough: true, footnotes: true, superscript: true, highlight: true)
          markdown.render value['value']
        end

      end

    end
  end
end
