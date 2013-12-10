module SoupCMS
  module Api


    class Application


      def initialize(name)
        @name = name
      end

      attr_reader :name

      def self.get(name)
        @@apps ||= {}
        if @@apps[name].nil?
          @@apps[name] = Application.new(name)
        end
        @@apps[name]
      end

    end



  end
end
