require 'jekyll-contentful-data-import/serializer'

module Jekyll
  module Contentful
    class DataExporter
      DATA_FOLDER = '_data'
      CONTENTFUL_FOLDER = 'contentful'
      SPACES_FOLDER = 'spaces'

      attr_reader :name, :entries, :config

      def initialize(name, entries, config = {})
        @name = name
        @entries = entries
        @config = config
      end

      def run
        setup_directory

        File.open(destination_file, 'w') do |file|
          file.write(::Jekyll::Contentful::Serializer.new(entries, config).to_yaml)
        end
      end

      def base_directory
        directory = File.expand_path(Dir.pwd)
        directory = File.join(directory, config['base_path']) if config.key?('base_path')

        directory
      end

      def destination_directory
        destination_dir = File.join(base_directory, DATA_FOLDER, CONTENTFUL_FOLDER, SPACES_FOLDER)
        destination_dir = File.join(base_directory, DATA_FOLDER, config['destination']) if config.key?('destination')

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
