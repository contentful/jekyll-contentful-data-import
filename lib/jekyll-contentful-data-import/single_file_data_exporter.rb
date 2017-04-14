require 'jekyll-contentful-data-import/base_data_exporter'

module Jekyll
  module Contentful
    # Single File Data Exporter Class
    #
    # Serializes Contentful data into a single YAML file
    class SingleFileDataExporter < BaseDataExporter
      def run
        setup_directory(destination_directory)

        File.open(destination_file, 'w') do |file|
          file.write(
            ::Jekyll::Contentful::Serializer.new(
              entries,
              config
            ).to_yaml
          )
        end
      end

      def destination_file
        File.join(destination_directory, "#{name}.yaml")
      end
    end
  end
end
