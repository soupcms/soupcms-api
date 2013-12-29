require 'redcarpet'
require 'coderay'
require 'cgi'

module SoupCMS
  module Api
    module Resolver

      class CodeRayHTML < Redcarpet::Render::HTML
        def block_code(code, language)
          return "<pre><code>#{CGI.escapeHTML(code)}</code></pre>" if language == nil || language == 'no-highlight'
          opts = {:wrap => :div, :line_numbers => :inline, :line_number_start => 1, :tab_width => 8,
                  :bold_every => 10, :css => :style}
          CodeRay.scan(code, language.to_sym).html(opts).chomp << "\n"
        end
      end


      class RedcarpetMarkdownResolver < Base

        def resolve(value, context)
          return value, true if value['type'] != 'markdown' || value['flavor'] != 'redcarpet'
          markdown = Redcarpet::Markdown.new(CodeRayHTML.new(with_toc_data: true), fenced_code_blocks: true, tables: true, autolink: true, strikethrough: true, footnotes: true, superscript: true, highlight: true)
          value['value'] = markdown.render(value['value'])
          return value, false
        end

      end

    end
  end
end
