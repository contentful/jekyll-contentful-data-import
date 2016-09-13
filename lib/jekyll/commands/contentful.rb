require 'jekyll-contentful-data-import/importer'

module Jekyll
  module Commands
    class Contentful < Command
      def self.init_with_program(prog)
        prog.command(:contentful) do |c|
          c.syntax 'contentful [OPTIONS]'
          c.description 'Imports data from Contentful'

          options.each {|opt| c.option(*opt) }

          c.action do |args, options|
            contentful_config = Jekyll.configuration['contentful']
            process args, options, contentful_config
          end
        end
      end

      def self.options
        [
          ['rebuild', '-r', '--rebuild', 'Rebuild Jekyll Site after fetching data'],
        ]
      end


      def self.process(args = [], options = {}, contentful_config = {})
        Jekyll.logger.info 'Starting Contentful import'

        Jekyll::Contentful::Importer.new(contentful_config).run

        Jekyll.logger.info 'Contentful import finished'

        if options['rebuild']
          Jekyll.logger.info 'Starting Jekyll Rebuild'

          Jekyll::Commands::Build.process(options)
        end
      end
    end
  end
end
