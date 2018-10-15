require 'rich_text_renderer'

module Jekyll
  module Contentful
    # Liquid filter for the RichText field.
    module RichTextFilter
      def rich_text(field, space = nil)
        return if field.nil?

        RichTextRenderer::Renderer.new(mappings_for(space)).render(field)
      end

      private

      def mappings_for(space)
        mappings = {}
        config_for(space).fetch('rich_text_mappings', {}).each do |k, v|
          mappings[k.to_s] = Module.const_get(v)
        end

        mappings
      end

      def config_for(space)
        config = @context.registers[:site].config['contentful']['spaces']

        # Spaces is a list of hashes indexed by space alias
        return config.first.first[1] if space.nil? # Return the first available configuration
        config.find { |sc| sc.key?(space) }[space]
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Contentful::RichTextFilter)
