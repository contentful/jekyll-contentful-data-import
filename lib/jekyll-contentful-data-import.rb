require 'jekyll-contentful-data-import/version'

%w{contentful}.each do |file|
  require File.expand_path("jekyll/commands/#{file}.rb", File.dirname(__FILE__))
end
