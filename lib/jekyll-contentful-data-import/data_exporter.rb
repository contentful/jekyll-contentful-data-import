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
        puts config
        export_fn = config['multiple_files'] ? export_by_content_type : export
        export_fn
      end

      def export
        grouped_entries = ::Jekyll::Contentful::Serializer.new(entries, config).serialize
        File.open(destination_file, 'w') do |file|
          file.write(YAML.dump(grouped_entries))
        end
      end

      def export_by_content_type
        grouped_entries = ::Jekyll::Contentful::Serializer.new(entries, config).serialize
        grouped_entries.each do |content_type, entry_list|
          File.open(destination_file(content_type), 'w') do |file|
            file.write(YAML.dump(entry_list))
          end
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

      def destination_file(file_name = name)
        File.join(destination_directory, "#{file_name}.yaml")
      end

      def setup_directory
        FileUtils.mkdir_p destination_directory
      end
    end
  end
end
