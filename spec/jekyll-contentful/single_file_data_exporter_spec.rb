require 'spec_helper'
require 'stringio'

describe Jekyll::Contentful::SingleFileDataExporter do
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

      it 'overriden directory' do
        subject = described_class.new('foo', [], {'base_path' => 'foo_dir'})

        expected = File.join(Dir.pwd, 'foo_dir', '_data', 'contentful', 'spaces')
        expect(subject.destination_directory).to eq(expected)
      end
    end

    describe '#destination_file' do
      it 'default directory' do
        expected = File.join(Dir.pwd, '_data', 'contentful', 'spaces', 'foo.yaml')
        expect(subject.destination_file).to eq(expected)
      end

      it 'overridden directory' do
        subject = described_class.new('foo', [], {'base_path' => 'foo_dir'})

        expected = File.join(Dir.pwd, 'foo_dir', '_data', 'contentful', 'spaces', 'foo.yaml')
        expect(subject.destination_file).to eq(expected)
      end

      it 'overridden destination' do
        subject = described_class.new('foo', [], {'base_path' => 'foo_dir', 'destination' => 'bar_path'})

        expected = File.join(Dir.pwd, 'foo_dir', '_data', 'bar_path', 'foo.yaml')
        expect(subject.destination_file).to eq(expected)
      end
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
