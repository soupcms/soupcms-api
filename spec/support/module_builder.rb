class ModuleBuilder

  def initialize
    @recipes = []
  end

  def with_recipe(recipe_hash)
    @recipes << recipe_hash
    self
  end

  def with_template(name,type = 'slim')
    @template = { 'type' => type, 'name' => name}
    self
  end

  def build
    module_hash = {}
    module_hash['recipes'] = @recipes
    module_hash['template'] = @template
    module_hash
  end

  def self.title_meta_module
    ModuleBuilder.new.with_template('meta/page-title')
  end

  def self.article_list_view_module
    recipe_json = <<-json
    {
      "type": "soupcms-api",
      "model": "posts",
      "return": "posts"
    }
    json
    ModuleBuilder.new.with_recipe(JSON.parse(recipe_json)).with_template('bootstrap/article-list-view')
  end

  def self.tag_cloud_module
    recipe_json = <<-json
    {
        "type": "soupcms-api",
        "url": "posts/tag-cloud",
        "return": "tag-cloud"
    }
    json
    ModuleBuilder.new.with_recipe(JSON.parse(recipe_json)).with_template('bootstrap/tag-cloud')
  end

  def self.any_module
    tag_cloud_module
  end
end