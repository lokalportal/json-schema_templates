# frozen_string_literal: true

describe Examples::HelperMethods::Schema,
         type: :integration,
         configuration: {additional_properties_on_objects: false, additional_properties_on_base_object: false} do
  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object additional_properties: false do
          array :objects do
            items do
              any_of [
                object(additional_properties: false) { string :name, enum: ['foo'] },
                object(additional_properties: false) { string :name, enum: ['bar'] },
                object(additional_properties: false) { string :name, enum: ['baz'] }
              ]
            end
          end
        end
      end
    end
  end
end
