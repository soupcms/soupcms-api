require 'spec_helper'

describe 'End 2 End API tests for blog post model' do

  describe 'data service' do

    it 'should return post as document objects' do
      BlogPostBuilder.new.create
      documents = SoupCMS::Api::DataService.model('sunitparekh', 'posts').fetch
      document = documents[0]
      expect(document).to be_kind_of(SoupCMS::Api::Document)
    end

    it 'should not return posts in draft state for published documents'

    it 'should by default sort on published date as latest posts'
    it 'should limit  posts to 2 when specified'

    it 'should by default limit to 10 published posts max'

    #it "should return a published blog post 'first post'"
    #it 'should return all the blog posts published and draft'
    #it "should return latest version of the blog post 'first post'"

  end

end