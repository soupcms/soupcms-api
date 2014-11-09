module SoupCMS
  module Api
    module Resolver
      module Markdown

        class LinkRef

          def resolve(html,context)
            doc = Nokogiri::HTML.fragment(html)
            links = doc.css('a')
            links.each do |link|
              next unless link['href'].start_with?('ref:')
              href = link['href']
              ref_doc, continue = ValueReferenceResolver.new.resolve(href, context)
              next if ref_doc == href
              link['href'] = SoupCMS::Api::Enricher::UrlEnricher.new(context).enrich(ref_doc)['url']
            end
            doc.to_html
          end


        end

      end
    end
  end
end
