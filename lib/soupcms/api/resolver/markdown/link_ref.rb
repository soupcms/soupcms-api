module SoupCMS
  module Api
    module Resolver
      module Markdown

        class LinkRef < Base

          def resolve(html)
            doc = Nokogiri::HTML.fragment(html)
            links = doc.css('a')
            links.each do |link|
              next unless link['href'].start_with?('ref:')
              ref_href = link['href']
              link['href'] = resolve_link(ref_href)
            end
            doc.to_html
          end

          def resolve_link(ref_href)
            ref_doc, continue = ValueReferenceResolver.new.resolve(ref_href, context)
            return ref_href if ref_doc == ref_href
            SoupCMS::Api::Enricher::UrlEnricher.new(context).enrich(ref_doc)['url']
          end


        end

      end
    end
  end
end
