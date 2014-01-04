module SoupCMS
  module Api

      class Router

        def initialize
          @routes = []
        end

        attr_reader :routes

        def add(route,controller_class)
          routes.push RouteMatcher.new(route,controller_class)
        end

        def resolve(path, request)
          url_parts = path.split('/')
          request.params['model_name'] = url_parts[0]

          matched_route = routes.find { |route| route.match(url_parts) }
          matched_route.params(url_parts).each do |key,value|
            request.params[key] = value
          end
          matched_route.controller_class
        end

      end

      class RouteMatcher

        def initialize(key,controller_class)
          @key = key
          @key_parts = key.split('/')
          @controller_class = controller_class
        end

        attr_reader :key_parts, :controller_class

        def match(url_parts)
          return false if url_parts.size != key_parts.size
          key_parts.each_index do |index|
            key = key_parts[index]
            next if key.match(/^:/)
            return false if key != url_parts[index]
          end
          true
        end

        def params(url_parts)
          params = {}
          key_parts.each_index do |index|
            key = key_parts[index]
            if key.match(/^:/)
              params[key.match(/^:/).post_match] = url_parts[index]
            end
          end
          params
        end

      end


  end
end
