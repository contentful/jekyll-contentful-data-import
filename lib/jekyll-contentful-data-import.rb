require 'jekyll-contentful-data-import/version'
require 'jekyll-contentful-data-import/helpers'

%w[contentful].each do |file|
  require File.expand_path("jekyll/commands/#{file}.rb", File.dirname(__FILE__))
end
