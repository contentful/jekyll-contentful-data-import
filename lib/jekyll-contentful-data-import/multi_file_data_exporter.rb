require 'jekyll-contentful-data-import/base_data_exporter'
require 'yaml'

module Jekyll
  module Contentful
    # Single File Data Exporter Class
    #
    # Serializes Contentful data into a multiple YAML files
    class MultiFileDataExporter < BaseDataExporter
      def run
        data = ::Jekyll::Contentful::Serializer.new(
          entries,
          config
        ).serialize

        data.each do |content_type, entries|
          content_type_directory = File.join(destination_directory, name, content_type.to_s)
          setup_directory(content_type_directory)

          entries.each do |entry|
            yaml_entry = YAML.dump(entry)

            File.open(destination_file(content_type_directory, entry), 'w') do |file|
              file.write(yaml_entry)
            end
          end
        end
      end

      def destination_file(content_type_directory, entry)
        File.join(content_type_directory, "#{entry['sys']['id']}.yaml")
      end
    end
  end
end
