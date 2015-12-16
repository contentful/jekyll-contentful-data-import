require 'spec_helper'
require 'stringio'

describe Jekyll::Contentful::DataExporter do
  subject { described_class.new('foo', []) }

  describe 'instance methods' do
    it '#destination_directory' do
      expected = File.join(Dir.pwd, '_data', 'contentful', 'spaces')
      expect(subject.destination_directory).to eq(expected)
    end

    it '#destination_file' do
      expected = File.join(Dir.pwd, '_data', 'contentful', 'spaces', 'foo.yaml')
      expect(subject.destination_file).to eq(expected)
    end

    it '#setup_directory' do
      expect(Dir).to receive(:mkdir).with(File.join(Dir.pwd, '_data'))
      expect(Dir).to receive(:mkdir).with(File.join(Dir.pwd, '_data', 'contentful'))
      expect(Dir).to receive(:mkdir).with(File.join(Dir.pwd, '_data', 'contentful', 'spaces'))

      subject.setup_directory
    end

    describe '#run' do
      before do
        allow(subject).to receive(:setup_directory)
      end

      it 'creates or overwrites data file' do
        expect(File).to receive(:open).with(subject.destination_file, 'w')
        subject.run
      end

      it 'serializes entries onto data file' do
        allow(File).to receive(:open).and_yield(StringIO.new)
        expect_any_instance_of(::Jekyll::Contentful::Serializer).to receive(:to_yaml)

        subject.run
      end
    end
  end
end
