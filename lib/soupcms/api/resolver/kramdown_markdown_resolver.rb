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
          html = resolve_references html, context
          value['value'] = html
          return value, false
        end

        def resolve_references(html, context)
          doc = Nokogiri::HTML(html)
          images = doc.xpath('//img')
          images.each do |image|
            next unless image['src'].start_with?('ref:')
            src = image['src']
            image_doc, continue = ValueReferenceResolver.new.resolve(src, context)
            image['data-src-desktop'] = File.join(base_url(image_doc,context),image_doc['desktop'])
            image['data-src-tablet'] = File.join(base_url(image_doc,context),image_doc['tablet']) if image_doc['tablet']
            image['data-src-mobile'] = File.join(base_url(image_doc,context),image_doc['mobile']) if image_doc['mobile']
            image.attributes['src'].remove
          end
          doc.to_html
        end

        def base_url(image_doc, context)
          image_doc['base_url'] || context.application['CLOUDINARY_BASE_URL'] || ENV['CLOUDINARY_BASE_URL']
        end
      end

    end
  end
end
