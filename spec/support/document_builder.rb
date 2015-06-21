require 'securerandom'
require 'mongo'

class DocumentBuilder

  def initialize model
    @model = model
    @data = {}
    application = SoupCMS::Common::Model::Application.new('soupcms-test','soupCMS Test','http://localhost:9292/api/soupcms-test','http://localhost:9292/soupcms-test','mongodb://127.0.0.1:27017/soupcms-test')
    @@db ||= Mongo::Client.new(application.mongo_uri).database
  end

  def with(data = {})
    @data.merge! data
    self
  end

  def add_common_fields
    doc_id = SecureRandom.uuid
    @data['doc_id'] = doc_id unless @data['doc_id']
    @data['slug'] = "slug-#{doc_id}" unless @data['slug']
    @data['tags'] = %w(tag1 tag2) unless @data['tags']
    timestamp = Time.now.to_i - 1000
    @data['publish_datetime'] = timestamp unless @data['publish_datetime']
    @data['version'] = timestamp unless @data['version']
    @data['locale'] = SoupCMS::Api::DocumentDefaults::DEFAULT_LOCALE unless @data['locale']
    @data['create_datetime'] = timestamp unless @data['create_datetime']
    @data['create_by'] = 'test-builder' unless @data['create_by']
    @data['state'] = SoupCMS::Api::DocumentState::DRAFT unless @data['state']
    @data['latest'] = false unless @data['latest']
  end

  def create
    result = @@db[@model].insert_one(build)
    result.inserted_id
  end

  def build
    add_missing_fields
    @data
  end

end