# frozen_string_literal: true

describe Examples::Objects::Schema, type: :integration do
  context 'when additional properties are disallowed on objects by default',
          configuration: {additional_properties_on_objects: false} do
    include_examples 'schema comparison' do
      let(:expected_schema_definition) do
        proc do
          object(additional_properties: false) do
            object :foo, additional_properties: true, required: true do # Overridden in the schema itself
              object :bar, additional_properties: false do
                string :baz
              end
            end
          end
        end
      end
    end
  end

  context 'when additional properties are allowed on objects by default',
          configuration: {additional_properties_on_objects: true} do
    include_examples 'schema comparison' do
      let(:expected_schema_definition) do
        proc do
          object(additional_properties: true) do
            object :foo, additional_properties: true, required: true do
              object :bar, additional_properties: true do
                string :baz
              end
            end
          end
        end
      end
    end
  end
end
