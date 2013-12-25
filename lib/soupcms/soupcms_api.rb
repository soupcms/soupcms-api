class SoupCMSApi

  def self.configure
    yield config
  end

  def self.config
    @@config ||= SoupCMS::Api::Utils::Config.new
  end


end