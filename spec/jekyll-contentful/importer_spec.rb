require 'spec_helper'

class EntryArrayDouble < ::Array
  def total
    size
  end
end

class ClientDouble
  def initialize(response = EntryArrayDouble.new)
    @response = response
  end

  def entries(options = {})
    @response
  end
end

class ExporterDouble
  def run; end
end

describe Jekyll::Contentful::Importer do
  before :each do
    allow(Jekyll.logger).to receive(:debug).with("Couldn't find custom mappers")
  end

  let(:config) do
    { 'contentful' => {
      'spaces' => [
        {
          'example' => {
            'space' => 'cfexampleapi',
            'access_token' => 'b4c0n73n7fu1'
          }
        }
      ]
    }}
  end
  subject { described_class.new(config) }

  describe 'instance methods' do
    it '#spaces' do
      expect(subject.spaces).to match([['example', {'space' => 'cfexampleapi', 'access_token' => 'b4c0n73n7fu1'}]])
    end

    describe '#client' do
      it 'creates client with some defaults' do
        expect(::Contentful::Client).to receive(:new).with(
          space: 'foo',
          access_token: 'foobar',
          environment: 'master',
          dynamic_entries: :auto,
          raise_errors: true,
          integration_name: 'jekyll',
          integration_version: Jekyll::Contentful::VERSION
        )

        subject.client('foo', 'foobar')
      end

      it 'can override the defaults' do
        expect(::Contentful::Client).to receive(:new).with(
          space: 'foo',
          access_token: 'foobar',
          environment: 'master',
          dynamic_entries: :auto,
          raise_errors: false,
          integration_name: 'jekyll',
          integration_version: Jekyll::Contentful::VERSION
        )

        subject.client('foo', 'foobar', 'master', raise_errors: false)
      end
    end

    describe '#value_for' do
      it 'returns set value regularly' do
        expect(subject.value_for({'foo' => 'bar'}, 'foo')).to eq 'bar'
      end

      it 'returns ENV value if prefixed with ENV_' do
        ENV['bar'] = 'bar_from_env'
        expect(subject.value_for({'foo' => 'ENV_bar'}, 'foo')).to eq 'bar_from_env'
      end
    end

    describe '#run' do
      it 'runs exporter for each space' do
        allow(subject).to receive(:spaces).and_return([['foo', {'space' => 'foo', 'access_token' => 'bar'}], ['bar', {'space' => 'bar', 'access_token' => 'foo'}]])
        allow(subject).to receive(:client).and_return(ClientDouble.new)

        expect(Jekyll::Contentful::SingleFileDataExporter).to receive(:new).and_return(ExporterDouble.new).twice

        subject.run
      end

      it 'runs exporter with correct arguments' do
        allow(subject).to receive(:client).and_return(ClientDouble.new)

        expect(Jekyll::Contentful::SingleFileDataExporter).to receive(:new).with('example', [], config['contentful']['spaces'].first['example']).and_return(ExporterDouble.new)

        subject.run
      end

      it 'runs multifile exporter when passed :individual_entry_files flag' do
        config = {
          'contentful' => {
            'spaces' => [
              {
                'example' => {
                  'space' => 'cfexampleapi',
                  'access_token' => 'b4c0n73n7fu1',
                  'individual_entry_files' => true
                }
              }
            ]
          }
        }
        subject = described_class.new(config)
        allow(subject).to receive(:client).and_return(ClientDouble.new)

        expect(Jekyll::Contentful::MultiFileDataExporter).to receive(:new).with('example', [], config['contentful']['spaces'].first['example']).and_return(ExporterDouble.new)

        subject.run
      end
    end

    describe '#get_entries' do
      it 'runs a single query by default' do
        client = ClientDouble.new
        expect(client).to receive(:entries).once

        subject.get_entries(client, {})
      end

      it 'fetches all entries when all_entries is set' do
        client = ClientDouble.new(EntryArrayDouble.new([1, 2, 3]))
        expect(client).to receive(:entries).and_call_original.twice

        subject.get_entries(client, {'all_entries' => true})
      end

      it 'can select page size when all_entries by using all_entries_page_size' do
        client = ClientDouble.new(EntryArrayDouble.new([1, 2, 3]))
        expect(client).to receive(:entries).and_call_original.exactly(3).times

        subject.get_entries(client, {'all_entries' => true, 'all_entries_page_size' => 2})
      end
    end
  end

  describe 'mappers are autoloaded' do
    let(:jekyll_config) do
      { 'contentful' => {
        'spaces' => [
          {
            'example' => {
              'space' => 'cfexampleapi',
              'access_token' => 'b4c0n73n7fu1'
            }
          }
        ]
      }}
    end

    it 'custom mappers are autoloaded' do
      config = jekyll_config.merge('source' => '.', 'plugins_dir' => '_plugins')

      allow(subject).to receive(:spaces).and_return([['foo', {'space' => 'foo', 'access_token' => 'bar'}], ['bar', {'space' => 'bar', 'access_token' => 'foo'}]])
      allow(subject).to receive(:client).and_return(ClientDouble.new)

      expect(Jekyll::Utils).to receive(:safe_glob).with(File.join('.', '_plugins', 'mappers'), File.join('**', '*.rb')) { ['some_mapper.rb'] }
      expect(Jekyll::External).to receive(:require_with_graceful_fail).with(['some_mapper.rb'])

      described_class.new(config)
    end

    it 'raises a warning if no mappers found' do
      allow(subject).to receive(:spaces).and_return([['foo', {'space' => 'foo', 'access_token' => 'bar'}], ['bar', {'space' => 'bar', 'access_token' => 'foo'}]])
      allow(subject).to receive(:client).and_return(ClientDouble.new)

      expect(Jekyll.logger).to receive(:debug).with("Couldn't find custom mappers")

      described_class.new(config)
    end
  end
end
