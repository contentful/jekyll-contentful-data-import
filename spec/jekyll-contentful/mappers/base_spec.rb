require 'spec_helper'

class SomeMapper
  def initialize(entry, config); end
  def map; end
end

describe Jekyll::Contentful::Mappers::Base do
  let(:entry) { EntryDouble.new('foo') }
  subject { described_class.new(entry, {}) }

  describe 'class methods' do
    describe '::mapper_for' do
      it 'returns default mapper if no config sent' do
        expect(described_class.mapper_for(entry, {})).to be_a described_class
      end

      it 'returns configured mapper if config sent' do
        config = {'content_types' => { entry.content_type.id => 'SomeMapper' } }
        expect(described_class.mapper_for(entry, config)).to be_a SomeMapper
      end
    end
  end

  describe 'instance methods' do
    describe '#map' do
      class FileDouble
        attr_reader :url

        def initialize(url)
          @url = url
        end
      end

      class AssetDouble < Contentful::Asset
        attr_reader :title, :description, :file
        def initialize(title, description, url, fields = nil)
          @title = title
          @description = description
          @file = FileDouble.new(url)
          @fields = {
            'en-US' => {
              title: title,
              description: description,
              file: file
            }
          } if fields.nil?

          @fields ||= fields
        end

        def fields(locale = nil)
          return { title: title, description: description, file: file } if locale.nil?
          @fields[locale]
        end
      end

      class LocationDouble < Contentful::Location
        def initialize(lat, lon)
          @lat = lat
          @lon = lon
        end

        def properties
          { 'lat' => @lat, 'lon' => @lon }
        end
      end

      class LinkDouble < Contentful::Link
        attr_reader :id

        def initialize(id)
          @id = id
        end
      end

      it 'maps a simple entry' do
        expected = { 'sys' => { 'id' => 'foo' } }
        expect(subject.map).to eq expected
      end

      it 'maps a complete entry' do
        entry = EntryDouble.new('foo', ContentTypeDouble.new, {
          'asset' => AssetDouble.new('some_title', 'foo', 'some_url'),
          'location' => LocationDouble.new(12.32, 43.34),
          'link' => LinkDouble.new('bar'),
          'entry' => EntryDouble.new('baz'),
          'array' => [
            LinkDouble.new('foobar'),
            'blah'
          ],
          'value' => 'foobar'
        })

        subject.instance_variable_set(:@entry, entry)

        expected = {
          'sys' => { 'id' => 'foo' },
          'asset' => {
            'title' => 'some_title',
            'description' => 'foo',
            'url' => 'some_url'
          },
          'location' => {
            'lat' => 12.32,
            'lon' => 43.34
          },
          'link' => {
            'sys' => { 'id' => 'bar' }
          },
          'entry' => {
            'sys' => { 'id' => 'baz' }
          },
          'array' => [
            { 'sys' => { 'id' => 'foobar' } },
            'blah'
          ],
          'value' => 'foobar'
        }

        expect(subject.map).to match expected
      end
    end
  end

  describe 'issues' do
    describe '#29 - Fix localized entries' do
      it 'should properly serialize a localized entry' do
        config = {'cda_query' => { 'locale' => '*' } }
        fields = {
          'en-US' => { 'foo' => 'bar' },
          'de-DE' => { 'foo' => 'baz' }
        }
        entry = EntryDouble.new('foo', ContentTypeDouble.new, fields, true)
        mapper = described_class.new(entry, config)

        expected = {
          'sys' => { 'id' => 'foo' },
          'foo' => {
            'en-US' => 'bar',
            'de-DE' => 'baz'
          }
        }

        expect(mapper.map).to match expected
      end
    end

    describe '#29 - Assets should pull the correct locale if the field is localized' do
      it 'should fetch the correct locale for the asset' do
        config = {'cda_query' => { 'locale' => '*' } }
        fields = {
          'en-US' => {
            'asset' => AssetDouble.new('some_title', 'foo', 'some_url')
          },
          'de-DE' => {
            'asset' => AssetDouble.new('some_title', 'foo', 'some_url', {
                'de-DE' => {
                  title: 'other_title',
                  description: 'other description',
                  file: FileDouble.new('other_url')
                }
            })
          }
        }
        entry = EntryDouble.new('foo', ContentTypeDouble.new, fields, true)
        mapper = described_class.new(entry, config)

        expected = {
          'sys' => { 'id' => 'foo' },
          'asset' => {
            "en-US" => {
              "title" => "some_title",
              "description" => "foo",
              "url" => 'some_url'
            },
            "de-DE" => {
              "title" => "other_title",
              "description" => "other description",
              "url" => 'other_url'
            }
          }
        }

        expect(mapper.map).to match expected
      end
    end
  end
end
