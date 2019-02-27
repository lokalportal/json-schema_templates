# frozen_string_literal: true

describe Examples::Entities::Schema,
         type: :integration,
         configuration: {additional_properties_on_objects: false, additional_properties_on_base_object: false} do
  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object additional_properties: false do
          entity :something, required: true do
            any_of [
              object(additional_properties: false) { string(:bar) },
              object(additional_properties: false) { string(:baz) }
            ]
          end
        end
      end
    end
  end
end
