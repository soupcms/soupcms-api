source 'https://rubygems.org'

gemspec

if RUBY_PLATFORM=~ /x86_64-darwin13/
  gem 'soupcms-common', path: '../soupcms-common'
else
  gem 'soupcms-common', github: 'soupcms/soupcms-common'
end


group :development do
  gem 'puma'
  gem 'rack-cache'
  gem 'redcarpet'
  gem 'kramdown'
  gem 'coderay'
end

group :test do
  gem 'rspec', '~> 3.0.0.beta1'
  gem 'rake'
  gem 'rack-test'
end