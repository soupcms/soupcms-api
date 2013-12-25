# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soupcms/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'soupcms-api'
  spec.version       = Soupcms::Api::VERSION
  spec.authors       = ['Sunit Parekh']
  spec.email         = ['parekh.sunit@gmail.com']
  spec.summary       = %q{soupCMS api project provides generic API for editorial data like blog posts, authors etc.}
  spec.description   = %q{soupCMS api project provides generic API for editorial data like blog posts, authors etc.}
  spec.homepage      = 'http://www.soupcms.com/soucms-api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency('mongo')
  spec.add_dependency('bson_ext')

  spec.add_dependency('redcarpet')
  spec.add_dependency('rouge')
end
