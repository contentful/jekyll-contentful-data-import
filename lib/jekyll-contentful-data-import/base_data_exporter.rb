require 'jekyll-contentful-data-import/serializer'

module Jekyll
  module Contentful
    # Base Data Exporter Class
    #
    # Generic Data Exporter Implementation
    class BaseDataExporter
      attr_reader :name, :entries, :config

      def initialize(name, entries, config = {})
        @name = name
        @entries = entries
        @config = config
      end

      def run
        raise 'must implement'
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
          base_directory, data_folder,
          contentful_folder, spaces_folder
        )
        if config.key?('destination')
          destination_dir = File.join(
            base_directory, data_folder, config['destination']
          )
        end

        destination_dir
      end

      def setup_directory(directory)
        FileUtils.mkdir_p(directory)
      end

      protected

      def data_folder
        '_data'
      end

      def contentful_folder
        'contentful'
      end

      def spaces_folder
        'spaces'
      end
    end
  end
end
