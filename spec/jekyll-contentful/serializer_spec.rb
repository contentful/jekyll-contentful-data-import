require 'spec_helper'

describe Jekyll::Contentful::Serializer do
  let(:entries) { [EntryDouble.new('foo')] }
  subject { described_class.new(entries, {}) }

  describe 'instance methods' do
    describe '#serialize' do
      describe 'uses proper mapper' do
        it 'uses default mappen if none specified in config' do
          expect_any_instance_of(Jekyll::Contentful::Mappers::Base).to receive(:map)

          subject.serialize
        end

        it 'uses specified mapper' do
          subject.instance_variable_set(:@config, {'content_types' => {'content_type' => 'MapperDouble'}})

          expect_any_instance_of(MapperDouble).to receive(:map)

          subject.serialize
        end
      end

      it 'serializes a single entry without fields' do
        expected = {'content_type' => [{'sys' => {'id' => 'foo'}}]}
        expect(subject.serialize).to eq(expected)
      end

      it 'serializes a single entry with fields' do
        subject.instance_variable_set(:@entries, [EntryDouble.new('foo', ContentTypeDouble.new, {'foobar' => 'bar'})])

        expected = {'content_type' => [{'sys' => {'id' => 'foo'}, 'foobar' => 'bar'}]}
        expect(subject.serialize).to eq(expected)
      end

      it 'serializes a nested entry like an entry' do
        subject.instance_variable_set(:@entries, [
          EntryDouble.new('foo', ContentTypeDouble.new, {
            'foobar' => EntryDouble.new('foobar', ContentTypeDouble.new, {
                'baz' => 1
            })
          })
        ])

        expected = {'content_type' => [{'sys' => {'id' => 'foo'}, 'foobar' => {'sys' => {'id' => 'foobar'}, 'baz' => 1}}]}
        expect(subject.serialize).to eq(expected)
      end

      it 'serializes multiple entries' do
        subject.instance_variable_set(:@entries, [
          EntryDouble.new('foo', ContentTypeDouble.new, {'foobar' => 'bar'}),
          EntryDouble.new('bar', ContentTypeDouble.new, {'foobar' => 'baz'})
        ])

        expected = {
          'content_type' => [
            {'sys' => {'id' => 'foo'}, 'foobar' => 'bar'},
            {'sys' => {'id' => 'bar'}, 'foobar' => 'baz'}
          ]
        }
        expect(subject.serialize).to match(expected)
      end
    end

  end
end
