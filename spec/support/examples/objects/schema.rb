# frozen_string_literal: true

module Examples
  module Objects
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        object :foo, additional_properties: true, required: true do
          object :bar do
            string :baz
          end
        end
      end
    end
  end
end
