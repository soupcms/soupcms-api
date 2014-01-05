module SoupCMS
  module Api
    module Route

      class MultiKeyValueRoute < SoupCMS::Common::Route

        def initialize(controller_class)
          @controller_class = controller_class
        end

        attr_reader :controller_class


        def match(url_parts)
          url_parts.size > 1 && url_parts.size.odd?
        end

        def params(url_parts)
          params = {}
          params['model_name'] = url_parts[0]
          params['filters'] = []
          url_parts.each_index do |index|
            next if (index == 0 || index.even?)
            key = url_parts[index]
            value = url_parts[index+1]
            params['filters'].push key
            params[key] = value
          end
          params
        end

      end


    end
  end
end

