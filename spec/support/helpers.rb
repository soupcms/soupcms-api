module Helpers

  def application
    SoupCMS::Common::Model::Application.new('soupcms-test','soupCMS Test','http://localhost:9292/api/soupcms-test','http://localhost:9292/soupcms-test','mongodb://localhost:27017/soupcms-test','CLOUDINARY_BASE_URL'=>'http://cloudinary.com/')
  end

end