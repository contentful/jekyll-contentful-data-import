require 'contentful'

module Jekyll
  module Contentful
    module Mappers
      class Base
        def self.mapper_for(entry, config)
          ct = entry.content_type

          mapper_name = config.fetch(
            'content_types', {}
          ).fetch(
            ct.id, ::Jekyll::Contentful::Mappers::Base.to_s
          )

          Module.const_get(mapper_name).new(entry, config)
        end

        attr_reader :entry, :config

        def initialize(entry, config)
          @entry = entry
          @config = config
        end

        def map
          result = {'sys' => {'id' => entry.id}}

          fields = has_multiple_locales? ? entry.fields_with_locales : entry.fields

          fields.each do |k, v|
            name, value = map_field k, v
            result[name] = value
          end

          result
        end

        def has_multiple_locales?
          config.fetch('cda_query', {}).fetch(:locale, nil) == '*'
        end

        def map_field(field_name, field_value)
          value_mapping = map_value(field_value)
          return field_name.to_s, value_mapping
        end

        def map_value(value)
          case value
          when ::Contentful::Asset
            map_asset(value)
          when ::Contentful::Location
            map_location(value)
          when ::Contentful::Link
            map_link(value)
          when ::Contentful::DynamicEntry
            map_entry(value)
          when ::Array
            map_array(value)
          else
            value
          end
        end

        def map_asset(asset)
          {'title' => asset.title, 'url' => asset.file.url}
        end

        def map_entry(child)
          self.class.mapper_for(child, config).map
        end

        def map_location(location)
          location.properties
        end

        def map_link(link)
          {'sys' => {'id' => link.id}}
        end

        def map_array(array)
          array.map {|element| map_value(element)}
        end
      end
    end
  end
end
