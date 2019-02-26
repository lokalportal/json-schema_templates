# frozen_string_literal: true

module IntegrationHelper
  extend RSpec::SharedContext

  let(:schema) { described_class.new.schema }
  let(:json) { schema.as_json }
  let(:expected_json) { expected_schema.as_json }

  let(:expected_schema) do
    expected_schema_definition.yield_self do |definition|
      Class.new do
        include ::JSON::SchemaBuilder
        define_method(:schema, &definition)
      end.new.schema
    end
  end

  shared_examples 'schema comparison' do
    it 'generates the expected schema' do
      expect(json).to eql expected_json
    end
  end
end
