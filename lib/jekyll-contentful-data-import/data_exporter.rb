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

      def destination_directory
        base_directory = File.expand_path(Dir.pwd)
        File.join(base_directory, DATA_FOLDER, CONTENTFUL_FOLDER, SPACES_FOLDER)
      end

      def destination_file
        File.join(destination_directory, "#{name}.yaml")
      end

      def setup_directory
        data_folder = File.join(Dir.pwd, DATA_FOLDER)
        Dir.mkdir(data_folder) unless Dir.exist?(data_folder)

        contentful_folder = File.join(data_folder, CONTENTFUL_FOLDER)
        Dir.mkdir(contentful_folder) unless Dir.exist?(contentful_folder)

        spaces_folder = File.join(contentful_folder, SPACES_FOLDER)
        Dir.mkdir(spaces_folder) unless Dir.exist?(spaces_folder)
      end
    end
  end
end
