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
            name, value = map_field(k, v, has_multiple_locales?)
            result[name] = value
          end

          result
        end

        def has_multiple_locales?
          config.fetch('cda_query', {}).fetch('locale', nil) == '*'
        end

        def map_field(field_name, field_value, multiple_locales = false)
          value_mapping = nil

          if multiple_locales
            value_mapping = {}
            field_value.each do |locale, value|
              value_mapping[locale.to_s] = map_value(value, locale.to_s)
            end
          else
            value_mapping = map_value(field_value)
          end

          return field_name.to_s, value_mapping
        end

        def map_value(value, locale = nil)
          case value
          when ::Contentful::Asset
            map_asset(value, locale)
          when ::Contentful::Location
            map_location(value)
          when ::Contentful::Link
            map_link(value)
          when ::Contentful::DynamicEntry
            map_entry(value)
          when ::Array
            map_array(value, locale)
          when ::Symbol
            value.to_s
          when ::Hash
            result = {}
            value.each do |k, v|
              result[k.to_s] = map_value(v, locale)
            end
            result
          else
            value
          end
        end

        def map_asset(asset, locale = nil)
          if locale
            file = asset.fields(locale)[:file]
            file_url = file.nil? ? '' : file.url

            return {
              'title' => asset.fields(locale)[:title],
              'description' => asset.fields(locale)[:description],
              'url' => file_url
            }
          end

          file = asset.file
          file_url = file.nil? ? '' : file.url

          {
            'title' => asset.title,
            'description' => asset.description,
            'url' => file_url
          }
        end

        def map_entry(child)
          self.class.mapper_for(child, config).map
        end

        def map_location(location)
          result = {}
          location.properties.each do |k, v|
            result[k.to_s] = v
          end
          result
        end

        def map_link(link)
          {'sys' => {'id' => link.id}}
        end

        def map_array(array, locale)
          array.map {|element| map_value(element, locale)}
        end
      end
    end
  end
end
