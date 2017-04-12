require 'jekyll-contentful-data-import/serializer'

module Jekyll
  module Contentful
    # Data Exporter Class
    #
    # Serializes Contentful data into YAML files
    class DataExporter
      DATA_FOLDER = '_data'.freeze
      CONTENTFUL_FOLDER = 'contentful'.freeze
      SPACES_FOLDER = 'spaces'.freeze

      attr_reader :name, :entries, :config

      def initialize(name, entries, config = {})
        @name = name
        @entries = entries
        @config = config
      end

      def run
        setup_directory

        File.open(destination_file, 'w') do |file|
          file.write(
            ::Jekyll::Contentful::Serializer.new(
              entries,
              config
            ).to_yaml
          )
        end
      end

      def base_directory
        directory = File.expand_path(Dir.pwd)
        if config.key?('base_path')
          directory = File.join(
            directory,
            config['base_path']
          )
        end

        directory
      end

      def destination_directory
        destination_dir = File.join(
          base_directory, DATA_FOLDER,
          CONTENTFUL_FOLDER, SPACES_FOLDER
        )
        if config.key?('destination')
          destination_dir = File.join(
            base_directory, DATA_FOLDER, config['destination']
          )
        end

        destination_dir
      end

      def destination_file
        File.join(destination_directory, "#{name}.yaml")
      end

      def setup_directory
        FileUtils.mkdir_p destination_directory
      end
    end
  end
end
