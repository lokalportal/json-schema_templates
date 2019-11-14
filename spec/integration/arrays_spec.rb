# frozen_string_literal: true

describe Examples::Arrays::Schema, type: :integration,
         configuration: {additional_properties_on_objects: false} do

  include_examples 'schema comparison' do
    let(:expected_schema_definition) do
      proc do
        object(additional_properties: false) do
          array :cars do
            items do
              object additional_properties: false do
                string :manufacturer
                array :extras, required: true do
                  items do
                    any_of [
                      object(additional_properties: false) { # rubocop:disable Style/BlockDelimiters
                        string(:type, enum: 'Tire')
                        string(:position, required: true)
                      },
                      object(additional_properties: false) { string(:type, enum: 'Wheel') }
                    ]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
