class SoupCMSApiRackApp

  def call(env)
    status = 200
    headers = {'Content-Type' => 'application/json'}

    request = Rack::Request.new(env)
    app_strategy = SoupCMSApi.config.application_strategy.new(request)
    request.params['app_name'] = app_strategy.app_name

    url_parts = app_strategy.path.split('/')
    request.params['model_name'] = url_parts[0]
    request.params['tags'] = [].concat([request.params['tags']].flatten.compact)
    request.params['filters'] = [].concat([request.params['filters']].flatten.compact)

    application = app_strategy.application
    context = SoupCMS::Api::Model::RequestContext.new(application, request.params)
    service = SoupCMS::Api::Service::DocumentService.new(context)

    if url_parts.size == 1
      result = service.fetch_all || []
    elsif url_parts[1] == 'tag-cloud'
      result = service.tag_cloud || []
    else
      request.params['key'] = url_parts[1]
      request.params['value'] = url_parts[2]
      result = service.fetch_one
      return [404, headers, [{ error: "Document #{request.params['value']} not found."}.to_json]] if result.nil?
    end

    headers.merge! SoupCMSApi.config.http_caching_strategy.new.headers(context) if context.environment == 'production'
    [status, headers, [result.to_json]]
  end

end