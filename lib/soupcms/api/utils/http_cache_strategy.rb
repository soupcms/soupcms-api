module SoupCMS
  module Api
    module Utils


      class HttpCacheStrategy

        @@max_age = 60 * 5 # 5 minutes

        def self.default_max_age=(seconds)
          @@max_age = seconds
        end

        def headers(context)
          return {} if context.drafts?
          {
              'Cache-Control' => "public, max-age=#{@@max_age}",
              'Expires' => CGI.rfc1123_date(Time.now.utc + @@max_age)
          }
        end

      end


    end
  end
end

