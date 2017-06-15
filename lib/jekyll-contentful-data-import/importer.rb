require 'contentful'
require 'jekyll-contentful-data-import/single_file_data_exporter'
require 'jekyll-contentful-data-import/multi_file_data_exporter'

module Jekyll
  module Contentful
    # Importer class
    #
    # Entry fetching logic
    class Importer
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def run
        spaces.each do |name, options|
          space_client = client(
            value_for(options, 'space'),
            value_for(options, 'access_token'),
            client_options(options.fetch('client_options', {}))
          )

          export_data(name, space_client, options)
        end
      end

      def export_data(name, space_client, options)
        entries = get_entries(space_client, options)

        if options.fetch('individual_entry_files', false)
          export_data_multiple_files(
            name,
            entries,
            options
          )
        else
          export_data_single_file(
            name,
            entries,
            options
          )
        end
      end

      def export_data_single_file(name, entries, options)
        Jekyll::Contentful::SingleFileDataExporter.new(
          name,
          entries,
          options
        ).run
      end

      def export_data_multiple_files(name, entries, options)
        Jekyll::Contentful::MultiFileDataExporter.new(
          name,
          entries,
          options
        ).run
      end

      def value_for(options, key)
        potential_value = options[key]
        return ENV[potential_value.gsub('ENV_', '')] if potential_value.start_with?('ENV_')
        potential_value
      end

      def spaces
        config['spaces'].map(&:first)
      end

      def get_entries(space_client, options)
        cda_query = options.fetch('cda_query', {})
        return space_client.entries(cda_query) unless options.fetch('all_entries', false)

        all = []
        query = cda_query.clone
        query[:order] = 'sys.createdAt' unless query.key?(:order)
        num_entries = space_client.entries(limit: 1).total

        page_size = options.fetch('all_entries_page_size', 1000)
        ((num_entries / page_size) + 1).times do |i|
          query[:limit] = page_size
          query[:skip] = i * page_size
          page = space_client.entries(query)
          page.each { |entry| all << entry }
        end

        all
      end

      def client(space, access_token, options = {})
        options = {
          space: space,
          access_token: access_token,
          dynamic_entries: :auto,
          raise_errors: true,
          integration_name: 'jekyll',
          integration_version: Jekyll::Contentful::VERSION
        }.merge(options)

        ::Contentful::Client.new(options)
      end

      private

      def client_options(options)
        options = options.each_with_object({}) do |(k, v), memo|
          memo[k.to_sym] = v
          memo
        end

        options.delete(:dynamic_entries)
        options.delete(:raise_errors)
        options
      end
    end
  end
end
