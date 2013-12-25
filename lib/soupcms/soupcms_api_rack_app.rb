class SoupCMSApiRackApp

  def call(env)
    status = 200
    headers = {'Content-Type' => 'application/json'}

    request = Rack::Request.new(env)

    url_parts = request.path.split('/')
    request.params['app_name'] = url_parts[2]
    request.params['model_name'] = url_parts[3]
    request.params['tags'] = [].concat([request.params['tags']].flatten.compact)
    request.params['filters'] = [].concat([request.params['filters']].flatten.compact)

    application = SoupCMS::Api::Model::Application.get(request.params['app_name'])
    context = SoupCMS::Api::Model::RequestContext.new(application, request.params)
    service = SoupCMS::Api::Service::DocumentService.new(context)

    if url_parts.size == 4
      result = service.fetch_all || []
    elsif url_parts[4] == 'tag-cloud'
      result = service.tag_cloud || []
    else
      request.params['key'] = url_parts[4]
      request.params['value'] = url_parts[5]
      result = service.fetch_one
      return [404, headers, [{ error: "Document #{request.params['value']} not found."}.to_json]] if result.nil?
    end

    headers.merge! SoupCMSApi.config.http_caching_strategy.new.headers(context) if context.environment == 'production'
    [status, headers, [result.to_json]]
  end

end