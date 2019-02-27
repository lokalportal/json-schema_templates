# frozen_string_literal: true

describe Examples::BaseObject::Schema, type: :integration do
  context 'when disallowing additional properties on the base object',
          configuration: {additional_properties_on_base_object: false} do
    include_examples 'schema comparison' do
      let(:expected_schema_definition) do
        proc do
          object additional_properties: false do
            string :foobar
          end
        end
      end
    end
  end

  context 'when allowing additional properties on the base object',
          configuration: {additional_properties_on_base_object: true} do
    include_examples 'schema comparison' do
      let(:expected_schema_definition) do
        proc do
          object additional_properties: true do
            string :foobar
          end
        end
      end
    end
  end
end
