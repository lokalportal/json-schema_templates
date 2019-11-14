# frozen_string_literal: true

module IntegrationHelper
  extend RSpec::SharedContext

  class TestRenderer
    include JSON::SchemaDsl

    def render(&definition)
      with_templates_disabled do
        instance_eval(&definition)
      end
    end

    def with_templates_disabled
      old_defaults = ::JSON::SchemaDsl.type_defaults.dup
      ::JSON::SchemaDsl.reset!
      result = yield.as_json
      ::JSON::SchemaTemplates.enable!
      ::JSON::SchemaDsl.type_defaults.merge!(old_defaults)
      result
    end
  end

  let(:test_renderer) { TestRenderer.new }
  let(:schema) { described_class.new.schema }
  let(:json) { schema.as_json }
  let(:expected_json) { expected_schema.as_json }

  let(:expected_schema) do
    test_renderer.render(&expected_schema_definition)
  end

  shared_examples 'schema comparison' do
    it 'generates the expected schema' do
      expect(json).to eql expected_json
    end
  end
end
