class SoupCMSApiRackApp


  def initialize
    @router = SoupCMS::Common::Router.new
    @router.add ':model_name', SoupCMS::Api::Controller::ModelController
    @router.add ':model_name/tag-cloud', SoupCMS::Api::Controller::TagCloudController
    @router.add_route SoupCMS::Api::Route::MultiKeyValueRoute.new(SoupCMS::Api::Controller::MultiKeyValueController)
  end

  attr_accessor :router

  def call(env)
    status = 200
    headers = {'Content-Type' => 'application/json'}

    request = Rack::Request.new(env)

    request.params['tags'] = [].concat([request.params['tags']].flatten.compact)
    request.params['filters'] = [].concat([request.params['filters']].flatten.compact)

    app_strategy = SoupCMSApi.config.application_strategy.new(request)
    request.params['app_name'] = app_strategy.app_name

    context = SoupCMS::Common::Model::RequestContext.new(app_strategy.application, request.params)
    result = router.resolve(app_strategy.path, request.params).new(context).execute

    if result.nil?
      return [404, headers, [{error: "Document #{app_strategy.path} not found."}.to_json]]
    else
      headers.merge! SoupCMSApi.config.http_caching_strategy.new.headers(request.params)
      [status, headers, [result.to_json]]
    end

  end

end