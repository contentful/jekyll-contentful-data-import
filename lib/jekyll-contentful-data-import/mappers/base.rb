require 'contentful'

module Jekyll
  module Contentful
    # Mappers module
    module Mappers
      # Base Mapper Class
      #
      # Logic for mapping entries into simplified serialized representations
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

        def map_entry_metadata
          content_type = entry.sys.fetch(:content_type, nil)
          {
            'id' => entry.sys.fetch(:id, nil),
            'created_at' => entry.sys.fetch(:created_at, nil),
            'updated_at' => entry.sys.fetch(:updated_at, nil),
            'content_type_id' => content_type.nil? ? nil : content_type.id,
            'revision' => entry.sys.fetch(:revision, nil)
          }
        end

        def map
          result = { 'sys' => map_entry_metadata }

          fields = multiple_locales? ? entry.fields_with_locales : entry.fields

          fields.each do |k, v|
            name, value = map_field(k, v, multiple_locales?)
            result[name] = value
          end

          result
        end

        def multiple_locales?
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

          [field_name.to_s, value_mapping]
        end

        def map_value(value, locale = nil)
          case value
          when ::Contentful::Asset
            map_asset(value, locale)
          when ::Contentful::Location
            map_location(value)
          when ::Contentful::Link
            map_link(value)
          when ::Contentful::Entry
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

        def map_asset_metadata(asset)
          {
            'id' => asset.id,
            'created_at' => asset.sys.fetch(:created_at, nil),
            'updated_at' => asset.sys.fetch(:updated_at, nil)
          }
        end

        def map_asset(asset, locale = nil)
          if locale
            file = asset.fields(locale)[:file]
            file_url = file.nil? ? '' : file.url

            return {
              'sys' => map_asset_metadata(asset),
              'title' => asset.fields(locale)[:title],
              'description' => asset.fields(locale)[:description],
              'url' => file_url
            }
          end

          file = asset.file
          file_url = file.nil? ? '' : file.url

          {
            'sys' => map_asset_metadata(asset),
            'title' => asset.title,
            'description' => asset.description,
            'url' => file_url
          }
        end

        def map_entry(child)
          self.class.mapper_for(child, config).map
        end

        def map_location(location)
          {
            'lat' => location.latitude,
            'lon' => location.longitude
          }
        end

        def map_link(link)
          {
            'sys' => {
              'id' => link.id
            }
          }
        end

        def map_array(array, locale)
          array.map { |element| map_value(element, locale) }
        end
      end
    end
  end
end
