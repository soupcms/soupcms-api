module SoupCMS
  module Api
    module Resolver


      class TagResolver < Base

        def resolve(values, context)
          return values,true unless values.kind_of?(Array)
          tags = values.collect do |value|
            { 'label' => value, 'link' => { 'match' => {'tags' => value} } }
          end
          return tags, true
        end

      end

    end
  end
end
