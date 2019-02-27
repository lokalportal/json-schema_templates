# frozen_string_literal: true

module Examples
  module Arrays
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        array :cars do
          items type: :object do
            string :manufacturer
            array :extras, required: true do
              items do
                any_of [
                  object { # rubocop:disable Style/BlockDelimiters
                    string(:type, enum: 'Tire')
                    string(:position, required: true)
                  },
                  object { string(:type, enum: 'Wheel') }
                ]
              end
            end
          end
        end
      end
    end
  end
end
