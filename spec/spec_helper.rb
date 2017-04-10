require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('lib', __FILE__)

require 'vcr'
require 'yaml'
require 'rspec'

require 'jekyll'
require File.expand_path('../../lib/jekyll-contentful-data-import.rb', __FILE__)

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_fixtures"
  config.hook_into :webmock
end

def vcr(cassette)
  VCR.use_cassette(cassette) do
    yield if block_given?
  end
end

def yaml(name)
  yaml = YAML.parse(File.read("spec/fixtures/yaml_fixtures/#{name}.yaml")).to_ruby
  yield yaml if block_given?
  yaml
end

class ContentTypeDouble
  attr_reader :id

  def initialize(id = 'content_type')
    @id = id
  end
end

class EntryDouble < Contentful::Entry
  attr_reader :id, :content_type

  def initialize(id = '', content_type = ContentTypeDouble.new, fields = {}, locales = false)
    @id = id
    @content_type = content_type

    @sys = { id: id, content_type: content_type, locale: 'en-US' }

    if locales
      @fields = fields
    else
      @fields = { 'en-US' => fields }
    end
  end

  def locale
    'en-US'
  end
end

class MapperDouble
  def initialize(entry, config); end
  def map; end
end
