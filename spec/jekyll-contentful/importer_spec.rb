require 'spec_helper'

class ClientDouble
  def entries(options = {})
    []
  end
end

class ExporterDouble
  def run; end
end

describe Jekyll::Contentful::Importer do
  let(:config) do
    {
      'spaces' => [
        {
          'example' => {
            'space' => 'cfexampleapi',
            'access_token' => 'b4c0n73n7fu1'
          }
        }
      ]
    }
  end
  subject { described_class.new(config) }

  describe 'instance methods' do
    it '#spaces' do
      expect(subject.spaces).to match([['example', {'space' => 'cfexampleapi', 'access_token' => 'b4c0n73n7fu1'}]])
    end

    describe '#client' do
      it 'creates client with some defaults' do
        expect(::Contentful::Client).to receive(:new).with(space: 'foo', access_token: 'foobar', dynamic_entries: :auto, raise_errors: true)

        subject.client('foo', 'foobar')
      end

      it 'can override the defaults' do
        expect(::Contentful::Client).to receive(:new).with(space: 'foo', access_token: 'foobar', dynamic_entries: :auto, raise_errors: false)

        subject.client('foo', 'foobar', raise_errors: false)
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

        expect(Jekyll::Contentful::DataExporter).to receive(:new).and_return(ExporterDouble.new).twice

        subject.run
      end

      it 'runs exporter with correct arguments' do
        allow(subject).to receive(:client).and_return(ClientDouble.new)

        expect(Jekyll::Contentful::DataExporter).to receive(:new).with('example', [], config['spaces'].first['example']).and_return(ExporterDouble.new)

        subject.run
      end
    end
  end
end
