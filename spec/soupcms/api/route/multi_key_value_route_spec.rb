require 'spec_helper'

describe SoupCMS::Api::Route::MultiKeyValueRoute do

  let(:route) { SoupCMS::Api::Route::MultiKeyValueRoute.new(SoupCMS::Api::Controller::MultiKeyValueController) }

  context 'match ' do

    it { expect(route.match('posts/slug/my-first-blog-post'.split('/'))).to eq(true) }
    it { expect(route.match('posts/slug/my-first-blog-post/version/5'.split('/'))).to eq(true) }
    it { expect(route.match('posts/slug/my-first-blog-post/tags/tag1/tags/tag2'.split('/'))).to eq(true) }

    it { expect(route.match('posts'.split('/'))).to eq(false) }
    it { expect(route.match('posts/slug'.split('/'))).to eq(false) }
    it { expect(route.match('posts/slug/my-first-blog-post/version/5/invalid'.split('/'))).to eq(false) }

  end

  context 'params' do
    it { expect(route.params('posts/slug/my-first-blog-post/version/5'.split('/'))).to eq({'model_name' => 'posts', 'filters' => %w(slug version), 'slug' => 'my-first-blog-post', 'version' => '5' }) }

    it { expect(route.params('posts/slug/my-first-blog-post/tags/tag1/tags/tag2/tags/tag3'.split('/'))).to eq({'model_name' => 'posts', 'filters' => %w(slug tags), 'slug' => 'my-first-blog-post', 'tags' => %w(tag1 tag2 tag3)}) }

  end

end