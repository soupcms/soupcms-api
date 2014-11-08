require 'redcarpet'
require 'coderay'
require 'cgi'

module SoupCMS
  module Api
    module Resolver

      class CodeRayHTML < Redcarpet::Render::HTML
        def self.options=(options)
          @@options = options
        end

        def options
          @@options ||= {:wrap => :div, :line_numbers => :inline, :line_number_start => 1, :tab_width => 8,
                        :bold_every => 10, :css => :style}

        end

        def block_code(code, language)
          return "<pre><code>#{CGI.escapeHTML(code)}</code></pre>" if language == nil || language == 'no-highlight'
          CodeRay.scan(code, language.to_sym).html(options).chomp << "\n"
        end
      end


      class RedcarpetMarkdownResolver < Base

        def self.options=(options)
          @@options = options
        end

        def options
          @@options ||= {fenced_code_blocks: true, tables: true, autolink: true, strikethrough: true, footnotes: true, superscript: true, highlight: true}

        end

        def resolve(value, context)
          return value, true if value['type'] != 'markdown' || value['flavor'] != 'redcarpet'
          markdown = Redcarpet::Markdown.new(CodeRayHTML.new(with_toc_data: true), options)
          html = markdown.render(value['value'])
          value['value'] = SoupCMS::Api::Resolver::Markdown::ImageRef.new.resolve(html,context)
          return value, false
        end

      end

    end
  end
end
