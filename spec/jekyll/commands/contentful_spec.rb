require 'spec_helper'

describe Jekyll::Commands::Contentful do
  describe 'class methods' do
    describe '::init_with_program' do
      it 'implements jekyll command interface' do
        expect(described_class.respond_to?(:init_with_program)).to be_truthy
      end
    end

    describe '::process' do
      it 'calls contentful importer' do
        expect_any_instance_of(Jekyll::Contentful::Importer).to receive(:run)

        described_class.process
      end

      it 'triggers a rebuild when --rebuild is sent' do
        allow_any_instance_of(Jekyll::Contentful::Importer).to receive(:run)
        expect(Jekyll::Commands::Build).to receive(:process)

        described_class.process([], {'rebuild' => true})
      end
    end
  end
end
