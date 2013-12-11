require 'securerandom'

class DocumentBuilder

  def initialize model
    @model = model
    @data = {}
    application = SoupCMS::Api::Model::Application.new('soupcms-test')
    @@db ||= SoupCMS::Api::MongoDbConnection.new(application).db
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
    add_missing_fields
    @@db.collection(@model).insert(@data)
  end

end