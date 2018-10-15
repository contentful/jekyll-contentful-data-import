# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/jekyll-contentful-data-import/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = "jekyll-contentful-data-import"
  s.version     = Jekyll::Contentful::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Contentful GmbH']
  s.email       = ["david.litvak@contentful.com"]
  s.homepage    = "https://www.contentful.com"
  s.summary     = %q{Include mangablable content from the Contentful CMS and API into your Jekyll projects}
  s.description = %q{Load blog posts and other managed content into Jekyll}
  s.license = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # The version of middleman-core your extension depends on
  s.add_dependency("jekyll", ">= 2.5.0", "< 4")

  # Additional dependencies
  s.add_dependency("contentful", '~> 2.1')
  s.add_dependency("rich_text_renderer", '~> 0.1')

  s.add_development_dependency 'rubygems-tasks', '~> 0.2'
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rubocop"
end
