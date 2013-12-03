require 'support/document_builder'

class BlogPostBuilder < DocumentBuilder

  def initialize
    super 'posts'
  end

  def add_missing_fields
    add_common_fields
    @data['title'] = 'My blog post' unless @data['title']
    @data['content'] = 'This is my blog post. Hope everyone likes it.' unless @data['post']
  end

end