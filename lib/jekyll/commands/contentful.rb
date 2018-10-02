require 'jekyll-contentful-data-import/importer'

module Jekyll
  # Module for Jekyll Commands
  module Commands
    # jekyll contentful Command
    class Contentful < Command
      def self.init_with_program(prog)
        prog.command(:contentful) do |c|
          c.syntax 'contentful [OPTIONS]'
          c.description 'Imports data from Contentful'

          options.each { |opt| c.option(*opt) }

          add_build_options(c)

          command_action(c)
        end
      end

      def self.options
        [
          [
            'rebuild', '-r', '--rebuild',
            'Rebuild Jekyll Site after fetching data'
          ]
        ]
      end

      def self.command_action(command)
        command.action do |args, options|
          jekyll_options = configuration_from_options(options)
          process args, options, jekyll_options
        end
      end

      def self.process(_args = [], options = {}, config = {})
        Jekyll.logger.info 'Starting Contentful import'

        Jekyll::Contentful::Importer.new(config).run

        Jekyll.logger.info 'Contentful import finished'

        return unless options['rebuild']

        Jekyll.logger.info 'Starting Jekyll Rebuild'
        Jekyll::Commands::Build.process(options)
      end
    end
  end
end
