require 'support/document_builder'

class ImageBuilder < DocumentBuilder

  def initialize
    super 'images'
  end

  def add_missing_fields
    @data['doc_id'] = 'posts/first-post/image.png' unless @data['doc_id']
    @data['desktop'] = 'v12345/desktopMD5.png' unless @data['desktop']
    @data['desktopMD5'] = 'desktopMD5' unless @data['desktopMD5']

    timestamp = Time.now.to_i - 1000
    @data['publish_datetime'] = timestamp unless @data['publish_datetime']
    @data['version'] = timestamp unless @data['version']
    @data['locale'] = SoupCMS::Api::DocumentDefaults::DEFAULT_LOCALE unless @data['locale']
    @data['create_datetime'] = timestamp unless @data['create_datetime']
    @data['create_by'] = 'test-builder' unless @data['create_by']
    @data['state'] = SoupCMS::Api::DocumentState::PUBLISHED unless @data['state']
    @data['latest'] = false unless @data['latest']
  end

end