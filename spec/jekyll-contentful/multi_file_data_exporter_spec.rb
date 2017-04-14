require 'spec_helper'
require 'stringio'

describe Jekyll::Contentful::MultiFileDataExporter do
  subject { described_class.new('foo', []) }

  describe 'instance methods' do
    describe '#base_directory' do
      it 'default directory' do
        expect(subject.base_directory).to eq(Dir.pwd)
      end

      it 'overridden directory' do
        subject = described_class.new('foo', [], {'base_path' => 'foo_dir'})

        expect(subject.base_directory).to eq(File.join(Dir.pwd, 'foo_dir'))
      end
    end

    describe '#destination_directory' do
      it 'default directory' do
        expected = File.join(Dir.pwd, '_data', 'contentful', 'spaces')
        expect(subject.destination_directory).to eq(expected)
      end

      it 'overridden directory' do
        subject = described_class.new('foo', [], {'base_path' => 'foo_dir'})

        expected = File.join(Dir.pwd, 'foo_dir', '_data', 'contentful', 'spaces')
        expect(subject.destination_directory).to eq(expected)
      end
    end

    it '#destination_file' do
      entry_double = { 'sys' => { 'id' => 'bar' } }
      expected = File.join('foo', 'bar.yaml')
      expect(subject.destination_file('foo', entry_double)).to eq(expected)
    end

    describe '#setup_directory' do
      it 'default directory' do
        expected = File.join(Dir.pwd, '_data', 'contentful', 'spaces')
        expect(FileUtils).to receive(:mkdir_p).with(expected)

        subject.setup_directory(expected)
      end

      it 'overridden directory' do
        subject = described_class.new('foo', [], {'base_path' => 'foo_dir'})

        expected = File.join(Dir.pwd, 'foo_dir', '_data', 'contentful', 'spaces')
        expect(FileUtils).to receive(:mkdir_p).with(expected)

        subject.setup_directory(expected)
      end
    end

    describe '#run' do
      before do
        allow(subject).to receive(:setup_directory)
      end

      it 'does nothing with no entries' do
        subject.run
      end

      it 'serializes entries' do
        expect_any_instance_of(::Jekyll::Contentful::Serializer).to receive(:serialize) { {} }

        subject.run
      end

      it 'creates a file per entry' do
        subject = described_class.new('foo', [EntryDouble.new('bar', ContentTypeDouble.new('bar_ct'))])

        expected_directory_path = File.join(Dir.pwd, '_data', 'contentful', 'spaces', 'foo', 'bar_ct')
        expect(FileUtils).to receive(:mkdir_p).with(expected_directory_path)
        expect(File).to receive(:open).with(File.join(expected_directory_path, 'bar.yaml'), 'w')

        subject.run
      end
    end
  end
end

