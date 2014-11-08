module SoupCMS
  module Api
    module Resolver
      module Markdown

        class ImageRef

          def resolve(html,context)
            doc = Nokogiri::HTML.fragment(html)
            images = doc.css('img')
            images.each do |image|
              next unless image['src'].start_with?('ref:')
              src = image['src']
              image_doc, continue = ValueReferenceResolver.new.resolve(src, context)
              next if image_doc == src
              if responsive?(image_doc)
                image['data-src-desktop'] = File.join(base_url(image_doc,context),image_doc['desktop'])
                image['data-src-tablet'] = File.join(base_url(image_doc,context),image_doc['tablet']) if image_doc['tablet']
                image['data-src-mobile'] = File.join(base_url(image_doc,context),image_doc['mobile']) if image_doc['mobile']
                image['class'] = "img-responsive default-responsive-image markdown-image #{image['class']}"
                image.attributes['src'].remove
              else
                image['src'] = File.join(base_url(image_doc,context),image_doc['desktop'])
                image['class'] = "img-responsive markdown-image #{image['class']}"
              end
            end
            doc.to_html
          end

          def responsive?(image_doc)
            image_doc['tablet'] || image_doc['mobile']
          end

          private
          def base_url(image_doc, context)
            image_doc['base_url'] || context.application['CLOUDINARY_BASE_URL'] || ENV['CLOUDINARY_BASE_URL']
          end


        end

      end
    end
  end
end
