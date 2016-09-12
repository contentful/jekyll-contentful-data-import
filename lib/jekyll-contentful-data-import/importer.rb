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
            space_client.entries(options.fetch('cda_query', {})),
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
