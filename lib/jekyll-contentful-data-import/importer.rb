require 'contentful'
require 'jekyll-contentful-data-import/data_exporter'

module Jekyll
  module Contentful
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

          Jekyll::Contentful::DataExporter.new(
            name,
            get_entries(space_client, options),
            options
          ).run
        end
      end

      def value_for(options, key)
        potential_value = options[key]
        return ENV[potential_value.gsub('ENV_', '')] if potential_value.start_with?('ENV_')
        potential_value
      end

      def spaces
        config['spaces'].map { |space_data| space_data.first }
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
          raise_errors: true
        }.merge(options)

        ::Contentful::Client.new(options)
      end

      private

      def client_options(options)
        options = options.each_with_object({}){|(k,v), memo| memo[k.to_sym] = v; memo}
        options.delete(:dynamic_entries)
        options.delete(:raise_errors)
        options
      end
    end
  end
end
