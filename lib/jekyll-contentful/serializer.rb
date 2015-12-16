require 'yaml'
require 'jekyll-contentful/mappers'

module Jekyll
  module Contentful
    class Serializer
      attr_reader :entries, :config

      def initialize(entries, config = {})
        @entries = entries
        @config = config
      end

      def serialize
        entries.map do |entry|
          ::Jekyll::Contentful::Mappers::Base.mapper_for(entry, config).map
        end
      end

      def to_yaml
        YAML.dump(serialize)
      end
    end
  end
end
