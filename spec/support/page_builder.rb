require 'support/document_builder'
require 'support/module_builder'

class PageBuilder < DocumentBuilder

  def initialize
    super 'pages'
    with_layout
    @areas = []
  end

  def with_layout(name = 'bootstrap/default',type = 'slim')
    @layout_hash = { 'type' => type, 'name' => name}
    self
  end

  def no_layout
    @layout_hash = {}
    self
  end

  def with_area(name,modules)
    @areas << { 'name' => name, 'modules' => modules }
    self
  end

  def add_missing_fields
    add_common_fields
    @data['layout'] = @layout_hash unless @layout_hash.empty?
    @data['areas'] = @areas unless @areas.empty?
  end

  def self.any_page
    PageBuilder.new.
        no_layout.
        with({'state' => SoupCMS::Api::DocumentState::PUBLISHED}).
        with_area('body',[ModuleBuilder.article_list_view_module.build])
  end

  def self.enricher_page
    PageBuilder.new.
        with({ 'meta' => { 'name' => 'enricher' }}).
        with_layout('bootstrap/sidebar').
        with({'state' => SoupCMS::Api::DocumentState::PUBLISHED}).
        with_area('meta',[ModuleBuilder.title_meta_module.build]).
        with_area('sidebar',[ModuleBuilder.tag_cloud_module.build])
  end

end