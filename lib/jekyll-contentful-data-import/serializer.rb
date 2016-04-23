require 'yaml'
require 'jekyll-contentful-data-import/mappers'

module Jekyll
  module Contentful
    class Serializer
      attr_reader :entries, :content_types, :config

      def initialize(entries, content_types, config = {})
        @entries = entries
        @content_types = content_types
        @config = config
      end

      def serialize
        result = {}
        content_type_keys = {}

        content_types.each do |content_type|
          content_type_keys[content_type.sys[:id]] = content_type.properties[:displayField].to_sym
        end

        puts content_type_keys

        entries.group_by { |entry| entry.content_type.id }.each do |content_type, entry_list|
          key = content_type_keys[content_type]
          result[content_type] = {} unless result.key? content_type
          entry_list.each do |entry|
            result[content_type][entry.fields[key]] = ::Jekyll::Contentful::Mappers::Base.mapper_for(entry, config).map
          end
        end

        result
      end

      def to_yaml
        YAML.dump(serialize)
      end
    end
  end
end
